module Qed
  module Mongodb
    class QueryBuilder
      QUERY_DATE_FIELD = :created_at

      def self.selector(fm, ext_options = {})
        raise Exception.new("key time_params is not allowed to have a nil object as value!") if (ext_options.key?(:time_params) and ext_options[:time_params].nil?)

        options     = default_options.merge(ext_options)
        query       = options[:clasz]

        query = build_from_date_time(query, fm.datetime, :time_params => options[:time_params])
        query = build_from_query(query, fm.query)

        if( query.is_a?(Mongoid::Criteria) )
          query = query.selector
        else
          query = nil
        end
        return query
      end

      def self.default_options
        {
            :time_params        => [QUERY_DATE_FIELD],
            :clasz              => Qed::Mongodb::MongoidModel
        }
      end

      def self.build_from_date_time(query, plugin, ext_options = {})
        options   = ext_options

        if( plugin && plugin.from && plugin.till )
          options[:time_params].each do |param|
            query = query.between((Marbu::Models::Misc::DOCUMENT_OFFSET+param.to_s).to_sym, plugin.from, plugin.till)
          end
        end

        return query
      end

      def self.build_from_query(query, plugin, ext_options = {})
        options       = ext_options

        if( plugin && plugin.values )
          plugin.values.each do |value|
            att = (Marbu::Models::Misc::DOCUMENT_OFFSET+value.key.to_s).to_sym

            if value.value.is_a?(Array) && value.value.size > 0
              if( value.value.size == 1)
                query = query.where(att.to_s => value.value[0])
              else
                query = query.where(att.in => value.value)
              end
            else
              query = query.where(att.to_s => value.value)
            end
          end
        end
        return query
      end
    end
  end
end
