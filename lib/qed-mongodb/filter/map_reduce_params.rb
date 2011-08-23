module Qed
  module Filter
    # holds all params that are passed in starting with "m_k_"
    class MapReduceParams
      PREFIX        = "m_k_"
      attr_accessor :emit_keys

      def self.clone(map_reduce_params)
        MapReduceParams.new(:emit_keys => map_reduce_params.emit_keys)
      end

      def initialize(params = {})
        int_params      = {:emit_keys => []}.merge(params)
        @emit_keys      = []

        add_emit_keys(int_params[:emit_keys])
      end

      def clone
        MapReduceParams.clone(self)
      end

      def add_emit_keys(emit_keys = [])
        raise Exception.new("emit_keys need to be an array") unless emit_keys.is_a?(Array)
        return if emit_keys.size == 0

        if( emit_keys.first.is_a?(Array))
          emit_keys.each {|emit_key| add_emit_key(emit_key.first, emit_key.second)}
        elsif( emit_keys.first.is_a?(Hash))
          emit_keys.each {|emit_key| add_emit_key(emit_key[:key], emit_key[:value])}
        elsif( emit_keys.first.is_a?(String))
          emit_keys.each {|emit_key| add_emit_key(emit_key)}
        elsif( emit_keys.first.is_a?(KeyValue))
          emit_keys.each {|emit_key| @emit_keys << emit_key.clone}
        else
          raise Exception.new("The type #{emit_keys.first.class} is not supported as type in emit_keys")
        end
      end

      def add_emit_key(key, value = nil)
        # if we get something like "param=value"
        splitted_key = key.split("=")

        if splitted_key.size == 1 || splitted_key.size == 2
          k = splitted_key.first.gsub(PREFIX,'')
          v = value || splitted_key.second

          @emit_keys << KeyValue.new(k, v)
        else
          raise Exception.new("Not sure what I should do with this parameter as key #{key} and this value #{value}")
        end
      end

      def get_emit_keys(format = :url)
        if format.eql?(:url)
          "".tap do |ret_val|
            @emit_keys.each do |emit_key|
              ret_val += PREFIX + emit_key.key + "=" + emit_key.value
            end
          end
        elsif format.eql?(:hash)
          raise Exception.new("Please implement hash format export")
        else
          raise Exception.new("Unknown format #{format} for #{self.class}.get_emit_keys")
        end
      end

      def serializable_hash
        {
            :emit_keys      => @emit_keys.collect(&:serializable_hash)
        }
      end
    end

    class KeyValue
      attr_accessor :key, :value

      def self.clone(key_value)
        KeyValue.new(key_value.key, key_value.value)
      end

      def initialize(key, value)
        @key = key
        @value = value
      end

      def clone
        KeyValue.clone(self)
      end

      def serializable_hash
        {
            :key              => @key,
            :value            => @value
        }
      end
    end
  end
end