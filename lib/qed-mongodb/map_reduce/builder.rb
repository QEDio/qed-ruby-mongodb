module Qed
  module Mongodb
    module MapReduce
      class Builder
        attr_accessor :mapreduce_keys, :mapreduce_values, :finalize_values, :database, :base_collection, :mr_collection
        attr_reader :reduce, :finalize, :query

        KEY = :mapreduce_keys
        MAPREDUCE_VALUES = :mapreduce_values
        FINALIZE_VALUES = :finalize_values

        MAP = :map
        REDUCE = :reduce
        FINALIZE = :finalize
        QUERY = :query
        DATABASE = :database
        BASE_COLLECTION = :base_collection
        MR_COLLECTION = :mr_collection

        ARRAY_INITS = [MAPREDUCE_VALUES, FINALIZE_VALUES]

        def initialize(params = {})
          @mapreduce_keys = []
          @mapreduce_values = []
          @finalize_values = []
          @map = nil
          @reduce = nil
          @finalize = nil
          @query = nil
          @database = nil
          @base_collection = nil
          @mr_collection = nil

          params.keys.each do |k|
            # generate key objects
            if k.eql?(KEY) and respond_to?(k)
              params[k].each do |kk|
                # add key object to key attr_accessor
                send("#{k}=".to_sym, send(k.to_sym) << Key.new(kk))
              end
            # generate value objects
            elsif ARRAY_INITS.include?(k) and respond_to?(k)
              params[k].each do |kk|
                # generate and add value object to corresponding attr_accessor
                send("#{k}=".to_sym, send(k.to_sym) << Value.new(kk))
              end
            else
              send("#{k}=".to_sym, params[k]) if respond_to?(k)
            end
          end
        end

        def mr_key
          [].tap do |arr|
            mapreduce_keys.each do |mapreduce_key|
              arr << mapreduce_key.name
            end
          end
        end

        # return true if we have a map and a reduce function defined
        def mapreduce?
          !(@map.nil? && @reduce.nil?)
        end

        def query_only?
          !mapreduce? && !@query.nil?
        end

        # sanatize JS in here
        def map=(m)
          @map = m
        end

        # sanatize JS in here
        def reduce=(r)
          @reduce = r
        end

        # sanatize JS in here
        def finalize=(f)
          @finalize = f
        end

        # sanatize JS in here
        def query=(q)
          @query = q
        end

        def map
          <<-JS
           function(){
              #{get_value(MAP)}
              #{@map}
              #{get_emit(MAP)}
            }
          JS
        end

        def reduce
          <<-JS
            function(key,values){
              #{get_value(REDUCE)}
              #{@reduce}
              #{get_emit(REDUCE)}
            }
          JS
        end

        def finalize
          <<-JS
            function(key, value){
              #{@finalize}
              #{get_emit(FINALIZE)}
            }
          JS
        end

      #  def map
      #    @map
      #  end

        def log
          self.to_s
        end

        def to_s
          puts "Map: #{map}"
          puts "Reduce: #{reduce}"
          puts "Finalize: #{finalize}"
        end

        class Key
          attr_accessor :name, :function

          def initialize(params = {})
            @name = nil
            @function = nil

            params.keys.each do |k|
              send("#{k}=".to_sym, params[k]) if respond_to?(k)
            end
          end
        end

        class Value
          attr_accessor :name, :function

          def initialize(params = {})
            @name = nil
            @function = nil

            params.keys.each do |k|
              send("#{k}=".to_sym, params[k]) if respond_to?(k)
            end
          end
        end

        private
          def get_value(function = MAP)
            case function
              when MAP        then "value=this.value;"
              when REDUCE     then "value=values[0];"
              else raise Exception.new("Value-foo for #{function} not defined!")
            end
          end

          def get_emit(function = MAP)
            case function
              when MAP        then emit_map
              when REDUCE     then emit_reduce
              when FINALIZE   then emit_finalize
              else raise Exception.new("Emit for #{function} not defined!")
            end
          end

        def emit_map
          emit = "emit( #{emit_keys}, "
          emit += emit_core
          emit += " );"
          return emit
        end

        def emit_reduce
          "return " + emit_core + ";"
        end

        def emit_finalize
          "return " + emit_core(@finalize_values) + ";"
        end

        def emit_keys(keys = mapreduce_keys)
          ret_val = ""
          keys.each do |k|
            ret_val += "#{k.function||k.name},"
          end
          # delete last comma
          return ret_val[0..ret_val.size-2]
        end

        def emit_core(values = mapreduce_values)
          core = "{ "
          values.each do |v|
            core += " #{v.name}: #{v.function||v.name},"
          end
          # delete last comma
          core = core[0..core.size-2]
          core += " }"
          return core
        end
      end
    end
  end
end
