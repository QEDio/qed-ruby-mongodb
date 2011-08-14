module Qed
  module Mongodb
    module MapReduce
      class Performer
        MONGO_HOST = '127.0.0.1'
        MONGO_PORT = 27017

        attr_reader :filter_mode, :mapreduce_models, :db

        # TODO: remove default param value!
        def initialize(filter_model, mr_config = Qed::Mongodb::StatisticViewConfigStore::PROFILE)
          init(filter_model, mr_config)
        end

        def mapreduce()
          data_hsh = Qed::Mongodb::MapReduce::Cache.find({:filter_model => @filter_model, :mapreduce_models => @mapreduce_models, :database => @db})

          if( data_hsh[:result].size == 0 )
            data_hsh = Qed::Mongodb::MapReduce::Cache.save({:cursor => int_mapreduce, :filter_model => @filter_model, :mapreduce_models => @mapreduce_models, :database => @db})
          end

          return data_hsh
        end

        def get_mr_key(mr_index = -1)
          mapreduce_models[mr_index].mr_key
        end

        private
          def init(filter_model, mr_config)
            raise Qed::Mongodb::Exceptions::OptionMisformed.new("Provided filter is not a FilterModel-Object!") unless filter_model.is_a?(Qed::Mongodb::FilterModel)

            @filter_model = filter_model
            # @mrm is an array, containing the configuration for all necessary mapreduces
            @mapreduce_models = Qed::Mongodb::StatisticViewConfig.create_config(@filter_model, mr_config)

            raise MapReduceConfigurationNotFound.new("Couldn't find any mapreduce configuration for this request.") if @mapreduce_models.size == 0

            @db = Mongo::Connection.new(MONGO_HOST, MONGO_PORT).db(@mapreduce_models[0].database)
          end

          def int_mapreduce
            if @mapreduce_models.size == 1 && @mapreduce_models.first.query_only?
              data_hsh = @db.collection(@mapreduce_models.first.base_collection).find(@mapreduce_models[0].query)
            else
              data_hsh = @db.collection(@mapreduce_models.first.base_collection)

              @mapreduce_models.each do |mrm|
                data_hsh = data_hsh.map_reduce(mrm.map, mrm.reduce, {:query => mrm.query, :out => {:replace => "tmp."+mrm.mr_collection}, :finalize => mrm.finalize})
              end
            end

            return data_hsh
          end
      end
    end
  end
end