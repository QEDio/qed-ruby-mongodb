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
            raise Qed::Mongodb::Exceptions::OptionMisformed.new("Provided filter is not a FilterModel-Object!")
          end

          @filter_model       = filter_model
          @mapreduce_models   = Qed::Mongodb::StatisticViewConfig.
                                  create_config(@filter_model, options[:config])

          if @mapreduce_models.size == 0
            raise MapReduceConfigurationNotFound.new("Couldn't find any mapreduce configuration for this request.")
          end

          @db                 = Mongo::Connection.new(MONGO_HOST, MONGO_PORT).db(@mapreduce_models[0].misc.database)
          @builder_klass      = options[:builder_klass]
          @cache              = options[:cache]
        end

        def default_options
          {
            :config         => Qed::Mongodb::StatisticViewConfigStore::PROFILE,
            :builder_klass  => Marbu::Builder,
            :cache          => true
          }
        end

        def mapreduce()
          if( cache )
            # TODO: mrapper should already be used here
            data_hsh = Qed::Mongodb::MapReduce::Cache.find(
                { :filter_model           => @filter_model,
                  :mapreduce_models       => @mapreduce_models,
                  :database               => @db
                }
            )

            if( !data_hsh[:cached] )
              data_hsh = Qed::Mongodb::MapReduce::Cache.save(
                  {
                      :cursor             => int_mapreduce,
                      :filter_model       => @filter_model,
                      :mapreduce_models   => @mapreduce_models,
                      :database           => @db
                  }
              )
            end
          else
            data_hsh = {:cached => false, :result => int_mapreduce.find().to_a }
          end

          return data_hsh
        end

        private
          def int_mapreduce
            coll = @db.collection(@mapreduce_models.first.misc.input_collection)

            @mapreduce_models.each do |mrm|
              builder = @builder_klass.new(mrm)

              coll = coll.map_reduce(
                builder.map, builder.reduce,
                {
                  :query => builder.query, :out => {:replace => "tmp."+mrm.misc.output_collection},
                  :finalize => builder.finalize
                }
              )
            end

            return coll
          end
      end
    end
  end
end