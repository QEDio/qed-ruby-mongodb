module Qed
  module Mongodb
    module MapReduce
      class Performer
        MONGO_HOST = '127.0.0.1'
        MONGO_PORT = 27017

        def self.mapreduce(filter_model)
          init(filter_model)
          int_mapreduce
        end

        #def self.conversion_by_channel_drilldown1(filter_model)
        #  # this should be a query on the mapreduced table from mapreduce2
        #  mapreduce1(filter_model)
        #end
        #
        ## API
        #def self.atomic(filter_model)
        #  filter_model.mongoid_condition(Qed::Mongodb::MongoidModel)
        #end
        #
        ## API
        #def self.mapreduce1(filter_model)
        #  init(filter_model, 0)
        #  int_mapreduce()
        #end
        #
        ## API
        #def self.mapreduce2(filter_model)
        #  init(filter_model, 1)
        #  int_mapreduce()
        #end


        private
          def self.init(filter_model)
            raise Qed::Mongodb::Exceptions::OptionMisformed.new("Provided filter is not a FilterModel-Object!") unless filter_model.is_a?(Qed::Mongodb::FilterModel)

            @filter_model = filter_model
            # @mrm is an array, containing the configuration for all necessary mapreduces
            @mapreduce_models = Qed::Mongodb::StatisticViewConfig.create_config(@filter_model)

            raise MapReduceConfigurationNotFound.new("Couldn't find any mapreduce configuration for this request.") if @mapreduce_models.size == 0

            # security, use only correct collection/db-names, a little bit weired, gerade ziehen
            #set_filter_model

            mongodb = @mapreduce_models[0].database

            @db = Mongo::Connection.new(MONGO_HOST, MONGO_PORT).db(mongodb)

          end

          #def self.set_filter_model
          #  @filter_model.replace_mongodb(
          #      {
          #        :base_collection  => @mrm.base_collection,
          #        :mr_collection    => @mrm.mr_collection,
          #        :database         => @mrm.database
          #      }
          #  )
          #  return @filter_model
          #end

          # returns data, therefore from API
          def self.int_mapreduce
            mr_cursor = nil

            if @mapreduce_models.size == 1 && @mapreduce_models[0].query_only?
              mr_cursor = @mapreduce_models[0].query
            else
              @mapreduce_models.each do |mrm|
                collection = @db.collection(mrm.base_collection)
                mr_cursor = collection.map_reduce(mrm.map, mrm.reduce, {:query => mrm.query, :out => {:replace => mrm.mr_collection }, :finalize => mrm.finalize})
              end
            end

            return mr_cursor
          end

          ## make sure we have symbols as keys, not strings
          #def self.convert_options(params)
          #  FilterModel.symbolize_keys(params)
          #end
      end
    end
  end
end