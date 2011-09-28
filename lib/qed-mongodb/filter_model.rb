require 'qed-mongodb/filter/map_reduce_params'

module Qed
  module Filter
    class FilterModel
      VIEW = :view

      #TODO: created_at needs methods that ensure that its always DateTime.to_time.utc!!
      attr_accessor :filter, :drilldown_level_current, :view, :mongodb, :frontend, :user, :created_at
      attr_accessor :map_reduce_params

      FROM_DATE = :from_date
      TILL_DATE = :till_date
      CREATED_AT = :created_at
      PRODUCT_UUID = :product_uuid
      INQUIRY_ID = :inquiry_id
      VALUE = :value
      STATUS_ID = :status_id
      DRILLDOWN_LEVEL_CURRENT = :drilldown_level_current
      DRILLDOWN_LEVEL_NEXT = :drilldown_level_next

      TIMEZONE = 2*60*60

      #### this defines two basic accessors for a row as returned by map-reduce
      #### if you change the way mapreduce returns its values you will have to change it here as well
      ROW_ID = :_id
      ROW_VALUE = :value

      PARAM_REJECTS = [:utf8, :authenticitiy_token, :action, :commit, :controller, :user]

      MONGODB_PARAMS_PRE = "m_"
      PARAM_INTEGER = "i_"
      PARAM_STRING = "s_"
      PARAM_FLOAT = "f_"

      URI_PARAMS_START = "?"
      URI_PARAMS_SEPARATOR = "&"
      URI_PARAMS_ASSIGN = "="

      PARAM_PRE = [MONGODB_PARAMS_PRE, PARAM_INTEGER, PARAM_STRING, PARAM_FLOAT]

      ATTRIBUTES = [:filter, :drilldown_level_current, VIEW, :mongodb, :frontend, :user, :created_at]

      MAP_REDUCE_PARAMS     = :map_reduce_params
      


      def self.clone(filter_model)
        cloned_filter                               = FilterModel.new
        cloned_filter.filter                        = filter_model.filter.clone
        cloned_filter.drilldown_level_current       = filter_model.drilldown_level_current
        cloned_filter.view                          = filter_model.view.clone
        cloned_filter.mongodb                       = filter_model.mongodb.clone
        cloned_filter.frontend                      = filter_model.frontend.clone
        cloned_filter.created_at                    = filter_model.created_at.clone
        cloned_filter.map_reduce_params             = filter_model.map_reduce_params.clone

        unless filter_model.user.nil?
          if filter_model.user.is_a?(Symbol)
            cloned_filter.user = filter_model.user
          else
            cloned_filter.user                          = filter_model.user.clone
          end
        end
        return cloned_filter
      end

      def initialize(params = nil)
        @created_at = {FROM_DATE => nil, TILL_DATE => nil}
        @filter = {}
        # 0 eqls top view (most reduced if you will)
        @drilldown_level_current = 0
        @mongodb = {}
        @view = nil
        @frontend = {}
        @user = nil

        @map_reduce_params = MapReduceParams.new

        unless params.blank?
          if params.is_a?(Hash)
            from_hash(params.symbolize_keys_rec)
          elsif params.is_a?(String)
            from_string(params)
          end
        end

        convert_to_utc
      end

      def set_times(from_date, till_date)
        @created_at[FROM_DATE] = from_date
        @created_at[TILL_DATE] = till_date
        convert_to_utc
      end

      def clone
        FilterModel.clone(self)
      end

      def serializable_hash(options = {:with_dates => true})
        default_options = {
            :filter                         => @filter,
            :drilldown_level_current        => @drilldown_level_current,
            :mongodb                        => @mongodb,
            :view                           => @view,
            :frontend                       => @frontend,
            :map_reduce_params              => @map_reduce_params.serializable_hash
          }

        if( options[:with_dates] )
          default_options.merge!(
            {
              :created_at                     => @created_at
            }
          )
        end

        return default_options
      end

      def digest(with_dates = true, clasz = Digest::SHA2)
        if( with_dates )
          clasz.hexdigest(serializable_hash().to_s)
        else
          clasz.hexdigest(serializable_hash({:with_dates => false}).to_s)
        end
      end

      def json
        Yajl::Encoder.encode(serializable_hash)
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
        if PARAM_PRE.include?(key[0..1])
          type = key[0..1]
          k = key[2..-1]
        else
          k = key
          type = nil
        end

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

      # TODO: merge with new version and then throw away
      # old version
      def urle(row=nil, column_key=nil, column_value=nil)
        cloned = self

        if( !row.nil? && !column_key.nil? && !column_value.nil?)
          cloned = FilterModel.clone(self)
          cloned.set_params(row, column_key, column_value)
        end

        int_url(cloned)
      end

      def url(row=nil, column_key=nil, column_value=nil, encode = true)
        cloned = self

        if( !row.nil? || (!column_key.nil? && !column_value.nil?))
          cloned = FilterModel.clone(self)
          cloned.set_params_e(Array(row['_id']), column_key, column_value)
        end

        int_url(cloned, encode)
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
      # hell this needs to be probably more intelligent than the whole business department at KP put together

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

      def set_params_e(emit_keys, filter_key, filter_value)
        @map_reduce_params.add_emit_keys(emit_keys)

        if filter_key && filter_value
          replace_filter({filter_key => {VALUE => filter_value}})
        end
      end

      # TODO:
      # shouldn't be in here
      # use Builder directly
      def mongodb_query(options = {})
        int_options = {
            :clasz =>  Qed::Mongodb::MongoidModel
        }.merge(options)

        Qed::Mongodb::QueryBuilder.selector(self, int_options)
      end

      def eql?(other)
        serializable_hash == other.serializable_hash
      end

      def ==(other)
        eql?(other)
      end

      def log
        puts ("FilterModel: #{self.inspect}")
      end

      class QueryParams

      end

      private
        # basically we have two modes in this method
        # serialize from internal (which don't have m_r_ stuff')
        # or serialize from external which do have this m_r_ stuff
        def add_param(param, value)
          if param.eql?(MAP_REDUCE_PARAMS.to_s)
            @map_reduce_params.add_emit_keys(value[:emit_keys])
          else
            # matches "m_k_xyz"
            param =~ /(.+?_.+?_)(.*)/

            case $1
              when MapReduceParams::PREFIX then @map_reduce_params.add_emit_key(param, value)
              else
                # don't use params we know we don't want
                return if PARAM_REJECTS.include?(param.to_sym)

                if param.starts_with?(MONGODB_PARAMS_PRE)
                  set_mongodb_param(param[2..-1],value)
                else
                  set_normal_param(param,value)
                end
            end
          end
        end

        # original method, takes the params from rails and converts it to an internal represenation
        # those params are the params provided by the browser
        def from_hash(params)
          # TODO: we should set a default date range here
          # we should set one, because otherwise we will mapreduce everything, but the default parameters should be
          # set somewhere else

          # hack, for now
          if !params[FROM_DATE].nil?
            @created_at[FROM_DATE] = params[FROM_DATE] || (Date.today - 1).to_s
            @created_at[TILL_DATE] = params[TILL_DATE] || Date.today.to_s

            #replace_filter({CREATED_AT => {FROM_DATE => Time.parse(from_date).utc, TILL_DATE => Time.parse(till_date).utc}})
            #replace_frontend({FROM_DATE => from_date})
            #replace_frontend({TILL_DATE => till_date})
          elsif !params[CREATED_AT].nil?
            @created_at[FROM_DATE] = params[CREATED_AT][FROM_DATE] || (Date.today - 1).to_s
            @created_at[TILL_DATE] = params[CREATED_AT][TILL_DATE] || Date.today.to_s
          end

          self.view = params[:action]

          params.each_pair do |k_sym,v|
            k = k_sym.to_s
            add_param(k, v)
          end
        end

        # currently we expect only to have a string if it's in json format
        def from_string(params)
          from_hash(Yajl::Parser.parse(params).symbolize_keys_rec)
        end

        def convert_to_utc
          if( @created_at )
            if( @created_at[:from_date].is_a?(String) )
              @created_at[:from_date] = Time.parse(@created_at[:from_date]).utc
            end

            if( @created_at[:till_date].is_a?(String))
              @created_at[:till_date] = Time.parse(@created_at[:till_date]).utc
            end
          end
        end

        def int_url(filter_model = self, encode = true)
          url = URI_PARAMS_START + url_view
          # TODO: we need to get rid of this drilldown level
          # it breaks basically everything
          url += URI_PARAMS_SEPARATOR + url_drilldown(filter_model.eql?(self))


          # handle from/till for created_at
          if @created_at and @created_at[FROM_DATE] and @created_at[TILL_DATE]
            url += URI_PARAMS_SEPARATOR + url_date(@created_at)
          end

          if filter_model.filter.any?
            filter_model.filter.each_pair do |k,v|
              if v.is_a?(Hash)
                url += URI_PARAMS_SEPARATOR + url_mongo_param(k, v)
              else
                raise Exception.new("Only Hash supported!")
              end
            end
          end

          url += URI_PARAMS_SEPARATOR + map_reduce_params.get_emit_keys(:url, true)

          if encode
            url = URI.escape(url)
          end
          
          return url
        end

        def parameter_url(param)
           parameter_type(param) + param.to_s
        end

        def parameter_type(param)
          case param
            when DRILLDOWN_LEVEL_CURRENT then PARAM_INTEGER
            else ''
          end
        end

        def url_view
          "#{VIEW}#{URI_PARAMS_ASSIGN}#{view}"
        end

        # TODO: we need to get rid of this drilldown level
        # TODO: NOW!!!!!!!!!!!!!!!!!
        def url_drilldown(current_level = true)
          drilldown_level = 0
          #drilldown_level = current_level ? drilldown_level_current : drilldown_level_next
          "#{parameter_url(DRILLDOWN_LEVEL_CURRENT)}#{URI_PARAMS_ASSIGN}#{drilldown_level}"
        end

        def url_date(hsh)
          "#{parameter_url(FROM_DATE)}#{URI_PARAMS_ASSIGN}#{hsh[FROM_DATE]}#{URI_PARAMS_SEPARATOR}#{parameter_url(TILL_DATE)}#{URI_PARAMS_ASSIGN}#{hsh[TILL_DATE]}"
        end

        def url_mongo_param(key, hsh)
          "#{MONGODB_PARAMS_PRE}#{get_type(hsh[VALUE])}#{key.to_s}#{URI_PARAMS_ASSIGN}#{hsh[VALUE]}"
        end
    end
  end
end
