module Qed
  module Mongodb
    module MapReduce
      class Performer
        MONGO_HOST = '127.0.0.1'
        MONGO_PORT = 27017

        def self.mapreduce(filter_model)
          # goes out to the api
          # the second mapreduce goes out to the api as well, in one single api call
          mapreduce1(filter_model)
          mapreduce2(filter_model)
        end

        def self.conversion_by_channel_drilldown1(filter_model)
          # this should be a query on the mapreduced table from mapreduce2
          # goes out to the api
          mapreduce1(filter_model)
        end

        # API
        def self.atomic(filter_model)
          filter_model.mongoid_condition(Qed::Mongodb::MongoidModel)
        end

        # API
        def self.mapreduce1(filter_model)
          init(filter_model, 0)
          int_mapreduce()
        end

        # API
        def self.mapreduce2(filter_model)
          init(filter_model, 1)
          int_mapreduce()
        end


        private
          def self.init(filter_model, level)
            raise Qed::Mongodb::Exceptions::OptionMisformed.new("Provided filter is not a FilterModel-Object!") unless filter_model.is_a?(Qed::Mongodb::FilterModel)

            @filter_model = filter_model
            @mrm = Qed::Mongodb::StatisticViewConfig.create_config(@filter_model, level)

            # security, use only correct collection/db-names, a little bit weired, gerade ziehen
            set_filter_model

            db = Mongo::Connection.new(MONGO_HOST, MONGO_PORT).db(@filter_model.mongodb[:database])
            @mr_collection = @filter_model.mongodb[:mr_collection]
            @collection = db.collection(@filter_model.mongodb[:base_collection])
          end

          def self.set_filter_model
            @filter_model.replace_mongodb(
                {
                  :base_collection  => @mrm.base_collection,
                  :mr_collection    => @mrm.mr_collection,
                  :database         => @mrm.database
                }
            )
            return @filter_model
          end

          # returns data, therefore from API
          def self.int_mapreduce
            @collection.map_reduce(@mrm.map, @mrm.reduce, {:query => @mrm.query, :out => {:replace => @mr_collection }, :finalize => @mrm.finalize})
          end

          ## make sure we have symbols as keys, not strings
          #def self.convert_options(params)
          #  FilterModel.symbolize_keys(params)
          #end
      end
    end
  end
end