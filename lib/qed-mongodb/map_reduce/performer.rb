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

          if( @filter_model.db.present? && @filter_model.db.cache.present? )
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

            if( !data_hsh[:cached] )
              data_hsh = mapreduce_cache_save
            end
          elsif Qstate::Plugin::Db::CACHE_VALUE_RENEW.include?(cache)
            data_hsh = mapreduce_cache_save
          else
            data_hsh = {:cached => false, :result => int_mapreduce.find().to_a }
          end

          return data_hsh
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

          def int_mapreduce
            coll = nil
            
            @mapreduce_models.each do |mrm|
              coll = @db.collection(mrm.misc.input_collection)
              builder = @builder_klass.new(mrm)

              #log(Rails.logger, builder, mrm)
              
              coll = coll.map_reduce(
                builder.map, builder.reduce,
                {
                  :query => builder.query, :out => {mrm.misc.output_operation.to_sym => mrm.misc.output_collection},
                  :finalize => builder.finalize
                }
              )
            end

            return coll
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