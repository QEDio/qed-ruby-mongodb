require 'qed-mongodb/filter/constants'

module Qed
  module RESTX
    class TimeParams
      TIME_PARAMS_PREFIX        = "t_"
      STEP_SIZE_ID              = "step_size"

      attr_accessor :from, :till
      attr_accessor :step_size

      def self.clone(time_params)
        from_serializable_hash(time_params.serializable_hash)
      end

      def self.from_serializable_hash(hsh)
        TimeParams.new(hsh.delete(:from), hsh.delete(:till), hsh)
      end

      def initialize(from, till, ext_options = {})
        #raise RuntimeError.new("Param 'ext_from' is not allowed to be nil") if from.nil?
        #raise RuntimeError.new("Param 'ext_till' is not allowed to be nil") if till.nil?

        options           = default_options.merge(ext_options)
        self.from         = from
        self.till         = till

        @step_size        = options[:step_size]
      end

      def default_options
        {
          :step_size      => 0
        }
      end

      def serializable_hash
        {
          :from       => from,
          :till       => till,
          :step_size  => step_size,
        }
      end

      def clone
        TimeParams.clone(self)
      end

      def from=(from)
        @from = TimeParams.convert_to_utc(from)
      end

      def till=(till)
        @till = TimeParams.convert_to_utc(till)
      end

      def url
        u = ""
        if( step_size != 0 )
          u += "#{TIME_PARAMS_PREFIX}#{STEP_SIZE_ID}#{Qed::RESTX::Constants::URI_PARAMS_ASSIGN}#{step_size}"
        end
        return u
      end

      def self.convert_to_utc(date)
        converted_date = nil

        if(date.is_a?(String))
          converted_date = Time.parse(date).utc
        else
          raise Exception.new("not supported yet")
        end

        return converted_date
      end
    end
  end
end