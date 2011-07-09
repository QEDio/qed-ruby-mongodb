module Qed
  module Mongodb
    module MapReduce
      class Builder
        attr_accessor :key, :mapreduce_values, :finalize_values, :database, :base_collection, :mr_collection
        attr_reader :reduce, :finalize, :query

        KEY = :key
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
          @key = Key.new
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
            if k.eql?(KEY)
              send("#{k}=".to_sym, Key.new(params[k])) if respond_to?(k)
            elsif ARRAY_INITS.include?(k) and respond_to?(k)
              params[k].each do |kk|
                send("#{k}=".to_sym, send(k.to_sym) << Value.new(kk))
              end
            else
              send("#{k}=".to_sym, params[k]) if respond_to?(k)
            end
          end
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
          emit = "emit( #{@key.function||@key.name}, "
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

        def emit_core(values = @mapreduce_values)
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
