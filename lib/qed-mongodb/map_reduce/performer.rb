# -*- encoding: utf-8 -*-
module Qed
  module Mongodb
    module MapReduce
      class Performer
        MONGO_HOST = '127.0.0.1'
        MONGO_PORT = 27017

        attr_reader :filter_model, :mapreduce_models, :db
        attr_accessor :cache

        def initialize( filter_model, ext_options = {} )
          options       = default_options.merge( ext_options.delete_if{|k,v|v.nil?} )

          unless filter_model.is_a?(Qstate::FilterModel)
            raise Qed::Mongodb::Exceptions::OptionMisformed.new('Provided filter is not a FilterModel-Object!')
          end

          @filter_model       = filter_model
          @mapreduce_models   = Qed::Mongodb::StatisticViewConfig.
                                  create_config(@filter_model, options[:config])

          if @mapreduce_models.size == 0
            raise MapReduceConfigurationNotFound.new('Couldnt find any mapreduce configuration for this request.')
          end

          @db                 = Mongo::Connection.new(MONGO_HOST, MONGO_PORT).db(@mapreduce_models[0].misc.database)
          @builder_klass      = options[:builder_klass]

          if @filter_model.db.present? && @filter_model.db.cache.present?
            @cache              = @filter_model.db.cache
          else
            @cache              = options[:cache]
          end
        end

        def default_options
          {
            :config         => Qed::Mongodb::StatisticViewConfigStore::PROFILE,
            :builder_klass  => Marbu::Builder,
            :cache          => Qstate::Plugin::Db::CACHE_VALUE_TRUE.first
          }
        end

        def mapreduce()
          if Qstate::Plugin::Db::CACHE_VALUE_TRUE.include?(cache)
            # TODO: mrapper should already be used here
            data_hsh = mapreduce_cache_find

            unless data_hsh[:cached]
              data_hsh = mapreduce_cache_save
            end
          elsif Qstate::Plugin::Db::CACHE_VALUE_RENEW.include?(cache)
            data_hsh = mapreduce_cache_save
          else
            query = Qed::Mongodb::MongoidModel.new()
            query = Qed::Mongodb::QueryBuilder.build_from_query(query, @filter_model.query, :mr_id => 'final')

            # this didn't work within the hash,
            res_coll, created_collections = int_mapreduce()
            res = res_coll.find(query.selector).to_a
            cleanup_mr_collections(created_collections)
            data_hsh = {:cached => false, :result => res, :created_collections => created_collections}
          end


          return data_hsh
        end

        def cleanup_mr_collections(created_collections)
          created_collections.each do |coll|
            @db.collection(coll).drop
          end
        end

        private
          def mapreduce_cache_find()
            Qed::Mongodb::MapReduce::Cache.find(
              {
                :filter_model           => @filter_model,
                :mapreduce_models       => @mapreduce_models,
                :database               => @db
              }
            )
          end

          def mapreduce_cache_save()
            Qed::Mongodb::MapReduce::Cache.save(
              {
                :cursor             => int_mapreduce,
                :filter_model       => @filter_model,
                :mapreduce_models   => @mapreduce_models,
                :database           => @db
              }
            )
          end

          def int_mapreduce(options = {})
            input_coll                 = nil
            coll_rand                  = "_" + rand(0..100000).to_s
            created_collections        = []
            
            @mapreduce_models.each_with_index do |mrm, i|
              retries = 0
              max_retries = 10

              begin
                input_coll_str  = mrm.misc.input_collection
                input_coll_str  += coll_rand if (i > 0 && !mrm.misc.input_collection_is_source)
                input_coll      = @db.collection(input_coll_str)

                output_coll = mrm.misc.output_collection + coll_rand
                created_collections << output_coll

                builder = @builder_klass.new(mrm)

                Rails.logger.info("#### input_coll: #{input_coll_str}")
                Rails.logger.info("#### output coll: #{output_coll}")
                log(Rails.logger, builder, mrm)

                input_coll = input_coll.map_reduce(
                  builder.map, builder.reduce,
                  {
                    :query => builder.query, :out => {mrm.misc.output_operation.to_sym => output_coll },
                    :finalize => builder.finalize
                  }
                )
              rescue Mongo::ConnectionFailure => e
                if retries < max_retries
                  retries += 1
                  sleep 0.2*retries*retries
                  retry
                else
                  raise e
                end
              end
            end

            return input_coll, created_collections
          end

          def log(logger, builder, mrm)
            logger.info "#######################################################"
            logger.info "input: #{mrm.misc.input_collection}"
            logger.info "ouput: #{mrm.misc.output_collection}"
            logger.info "map: #{builder.map}"
            logger.info "reduce: #{builder.reduce}"
            logger.info "finalize: #{builder.finalize}"
            logger.info "query: #{builder.query}"
            logger.info "#######################################################"
          end
      end
    end
  end
end