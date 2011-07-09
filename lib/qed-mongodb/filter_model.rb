module Qed
  module Mongodb
    class FilterModel
      attr_accessor :filter, :drilldown_level_current, :action_name, :mongodb, :frontend

      FROM_DATE = :from_date
      TILL_DATE = :till_date
      CREATED_AT = :created_at
      PRODUCT_UUID = :product_uuid
      INQUIRY_ID = :inquiry_id
      VALUE = :value
      STATUS_ID = :status_id
      DRILLDOWN_LEVEL_CURRENT = :drilldown_level_current
      DRILLDOWN_LEVEL_NEXT = :drilldown_level_next

      DOCUMENT_OFFSET = VALUE.to_s + "."
      TIMEZONE = 2*60*60

      #### this defines two basic accessors for a row as returned by map-reduce
      #### if you change the way mapreduce returns its values you will have to change it here as well
      ROW_ID = :_id
      ROW_VALUE = :value

      PARAM_REJECTS = [:utf8, :authenticitiy_token, :commit, :action, :controller]

      MONGODB_PARAMS_PRE = "m_"
      PARAM_INTEGER = "i_"
      PARAM_STRING = "s_"
      PARAM_FLOAT = "f_"

      ATTRIBUTES = [:filter, :drilldown_level_current, :action_name, :mongodb, :frontend]


      def self.clone(filter_model)
        cloned_filter = FilterModel.new
        cloned_filter.filter = filter_model.filter.clone
        cloned_filter.drilldown_level_current = filter_model.drilldown_level_current
        cloned_filter.action_name = filter_model.action_name.clone
        cloned_filter.mongodb = filter_model.mongodb.clone
        cloned_filter.frontend = filter_model.frontend.clone
        return cloned_filter
      end

      def initialize(params = nil)
        @filter = {}
        @drilldown_level_current = 0
        @mongodb = {}
        @action_name = nil
        @frontend = {}

        unless params.blank?
          if params.is_a?(Hash)
            from_hash(symbolize_keys(params))
          elsif params.is_a?(String)
            from_string(params)
          end
        end

        convert_to_utc
      end

      def hash
        {
          :filter                         => @filter,
          :drilldown_level_current        => @drilldown_level_current,
          :mongodb                        => @mongodb,
          :action_name                    => @action_name,
          :frontend                       => @frontend
        }
      end

      def json
        Yajl::Encoder.encode(hash)
      end

      def set_mongodb_param(key, value)
        type = key[0..1]
        k = key[2..-1]

        k, v = sanitize_mongo_param(k, value)
        v = convert_param(type, v)

        # TODO
        # this is really wired, it shoudl be replace_mongodb, but the current coding only works with replace_filter
        # for now I will leave it that way
        # but the I will let the test fail
        replace_filter({k => {VALUE => v}})
      end

      def set_normal_param(key, value)
        type = key[0..1]
        k = key[2..-1]

        if self.respond_to?(k)
          k, v = sanitize_normal_param(k, value)
          v = convert_param(type,v)
          send("#{k}=".to_sym, v)
        end
      end

      def sanitize_mongo_param(key, value)
        return key.to_sym, value
      end

      def sanitize_normal_param(key, value)
        return key, value
      end

      def convert_param(type, value)
        case type
          when PARAM_INTEGER then   value.to_i
          when PARAM_FLOAT then     value.to_f
          else value
        end
      end

      def replace_filter(params = {})
        @filter.merge!(params)
        return self
      end

      def replace_mongodb(params = {})
        @mongodb.merge!(params)
        return self
      end

      def replace_frontend(params = {})
        @frontend.merge!(params)
        return self
      end

      def drilldown_level_next
        @drilldown_level_current+1
      end

      def url(row, column_key, column_value)
        cloned = FilterModel.clone(self)
        cloned.set_params(row, column_key, column_value)

        url = action_name + "?i_drilldown_level_current=#{drilldown_level_next}&"

        if cloned.filter.any?
          cloned.filter.each_pair do |k,v|
            if v.is_a?(Hash)
              if v[FROM_DATE].present? and v[TILL_DATE].present?
                url += "from_date=#{v[FROM_DATE]}&till_date=#{v[TILL_DATE]}"
              else
                url += "&#{MONGODB_PARAMS_PRE}#{get_type(v[VALUE])}#{k.to_s}=#{v[VALUE]}"
              end
            else
              raise Exception.new("Only Hash supported!")
            end
          end
        end

        return url
      end

      def get_type(value)
        ret = nil

        if value.is_a?(String)
          ret = PARAM_STRING
        elsif value.is_a?(Integer)
          ret = PARAM_INTEGER
        elsif value.is_a?(Float)
          ret = PARAM_FLOAT
        end
        return ret
      end

      # here we decide what keys and values we use for the drilldown, this will be a major piece of code if
      # it's able to handle what we need
      # hell this needs to be probably more intelligent than the whole business department by KP put together

      # for now we make it stupid but functional
      # providing row here is maybe a little bit overkill, but what shells
      def set_params(row, column_key, column_value)
        # first: how do i know which field :_id is in the original table?
        # guess I don't. Easier to change the mapreduce function and don't show :_id in the output
        # therefore the first element returned from mapreduce will be the same as the :_id value

        # pivot element which this mapreduce result was summed up from, by convention the first element in our value-array
        # is this element (has the same value as row[:_id])
        # this filter is the same for one row
        pivot = row[ROW_VALUE.to_s].to_a[0]
        replace_filter({pivot[0].to_sym => {VALUE => pivot[1]}})
        replace_filter({column_key => {VALUE => column_value}})
      end

      def mongodb_query(clasz = Qed::Mongodb::MongoidModel)
        Qed::Mongodb::QueryBuilder.selector(self, clasz)
      end

      def offset
        DOCUMENT_OFFSET
      end

      def from_date
        FROM_DATE
      end

      def till_date
        TILL_DATE
      end

      def value
        VALUE
      end

      def eql?(other)
        hash == other.hash
      end

      def ==(other)
        eql?(other)
      end

      def log
        puts ("FilterModel: #{self.inspect}")
      end

      def symbolize_keys(obj)
        if obj.is_a?(Hash)
          obj.inject({}) do |options, (key, value)|
            options[(key.to_sym rescue key) || key] = (value.is_a?(Hash)||value.is_a?(Array)) ? symbolize_keys(value) : value
            options
          end
        elsif obj.is_a?(Array)
          obj.inject([]) do |options, value|
            options << ((value.is_a?(Hash)||value.is_a?(Array)) ? symbolize_keys(value) : value)
            options
          end
        else
          raise Exception("Can't do that!")
        end
      end

      private
        # original method, takes the params from rails and converts it to an internal represenation
        # those params are the params provided by the browser
        def from_hash(params)
          from_date = params[FROM_DATE] || (Date.today - 1).to_s
          till_date = params[TILL_DATE] || Date.today.to_s

          replace_filter({CREATED_AT => {FROM_DATE => Time.parse(from_date).utc, TILL_DATE => Time.parse(till_date).utc}})
          replace_frontend({FROM_DATE => from_date})
          replace_frontend({TILL_DATE => till_date})

          params.each_pair do |k_sym,v|
            k = k_sym.to_s
            # don't use params we know we don't want
            next if PARAM_REJECTS.include?(k.to_sym)

            if k.starts_with?(MONGODB_PARAMS_PRE)
              set_mongodb_param(k[2..-1],v)
            else
              set_normal_param(k,v)
            end
          end
        end

        # currently we expect only to have a string if it's in json format
        def from_string(params)
          tmp_hsh = symbolize_keys(Yajl::Parser.parse(params))

          ATTRIBUTES.each do |att|
             send("#{att}=".to_sym, tmp_hsh[att])
          end
        end

        def convert_to_utc
          if( @filter[:created_at][:from_date].is_a?(String) )
            @filter[:created_at][:from_date] = Time.parse(@filter[:created_at][:from_date]).utc
          end

          if( @filter[:created_at][:till_date].is_a?(String))
            @filter[:created_at][:till_date] = Time.parse(@filter[:created_at][:till_date]).utc
          end
        end
    end
  end
end
