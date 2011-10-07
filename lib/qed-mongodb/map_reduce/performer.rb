module Qed
  module Mongodb
    module MapReduce
      class Performer
        MONGO_HOST = '127.0.0.1'
        MONGO_PORT = 27017

        attr_reader :filter_model, :mapreduce_models, :db

        # TODO: remove default param value!
        def initialize(filter_model, mr_config = Qed::Mongodb::StatisticViewConfigStore::PROFILE, builder_clasz = Marbu::Builder)
          init(filter_model, mr_config, builder_clasz)
        end

        def mapreduce()
          # TODO: mrapper should already be used here
          data_hsh = Qed::Mongodb::MapReduce::Cache.find(
              { :filter_model           => @filter_model,
                :mapreduce_models       => @mapreduce_models,
                :database               => @db
              }
          )

          if( data_hsh[:result].size == 0 )
            data_hsh = Qed::Mongodb::MapReduce::Cache.save(
                {
                    :cursor             => int_mapreduce,
                    :filter_model       => @filter_model,
                    :mapreduce_models   => @mapreduce_models,
                    :database           => @db
                }
            )
          end

          return data_hsh
        end

        def get_mr_key(mr_index = -1)
          mapreduce_models[mr_index].mr_key
        end

        private
          def init(filter_model, mr_config, builder_clasz)
            raise Qed::Mongodb::Exceptions::OptionMisformed.new("Provided filter is not a FilterModel-Object!") unless filter_model.is_a?(Qaram::FilterModel)

            @filter_model = filter_model
            # @mrm is an array, containing the configuration for all necessary mapreduces
            @mapreduce_models = Qed::Mongodb::StatisticViewConfig.create_config(@filter_model, mr_config)

            raise MapReduceConfigurationNotFound.new("Couldn't find any mapreduce configuration for this request.") if @mapreduce_models.size == 0

            @db = Mongo::Connection.new(MONGO_HOST, MONGO_PORT).db(@mapreduce_models[0].database)
            @builder_clasz = builder_clasz
          end

          def int_mapreduce
            data_hsh = @db.collection(@mapreduce_models.first.base_collection)

            @mapreduce_models.each do |mrm|
              builder = @builder_clasz.new(mrm)

              #Rails.logger.warn("query: #{builder.query}")
              #puts("query: #{builder.query}")

              data_hsh = data_hsh.map_reduce(
                builder.map, builder.reduce,
                {
                  :query => builder.query, :out => {:replace => "tmp."+mrm.mr_collection},
                  :finalize => builder.finalize
                }
              )
            end

            return data_hsh
          end
      end
    end
  end
end