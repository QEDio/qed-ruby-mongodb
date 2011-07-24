module Qed
  module Mongodb
    module MapReduce
      class Performer
        MONGO_HOST = '127.0.0.1'
        MONGO_PORT = 27017

        def self.mapreduce(user, options)
          # goes out to the api
          # the second mapreduce goes out to the api as well, in one single api call
          mapreduce1(user, options)
          mapreduce2(user, options)
        end

        def self.conversion_by_channel_drilldown1(user, options)
          # this should be a query on the mapreduced table from mapreduce2
          # goes out to the api
          mapreduce1(user, options)
        end

        # API
        def self.atomic(user, options)
          filter_model = options[:filter]
          filter_model.mongoid_condition(Qed::Mongodb::MongoidModel)
        end

        # API
        def self.mapreduce1(user, options)
          init(user, options, 0)
          int_mapreduce()
        end

        # API
        def self.mapreduce2(user, options)
          init(user, options, 1)
          int_mapreduce()
        end


        private
          def self.init(user, options, level)
            raise Qed::Mongodb::Exceptions::OptionMisformed.new("Options has to be a hash") unless options.is_a?(Hash)
            raise Qed::Mongodb::Exceptions::OptionMisformed.new("Option needs to have at least :filter set") unless options[:filter]
            raise Qed::Mongodb::Exceptions::OptionMisformed.new("Provided filter is not a FilterModel-Object!") unless options[:filter].is_a?(Qed::Mongodb::FilterModel)
            options[:params] = convert_options(options[:params])

            @filter_model = options[:filter]
            @mrm = Qed::Mongodb::StatisticViewConfig.create_config(user, options[:params][:action].to_sym, @filter_model, level)

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

          # make sure we have symbols as keys, not strings
          def self.convert_options(params)
            FilterModel.symbolize_keys(params)
          end
      end
    end
  end
end