module Qed
  module Mongodb
    class QueryBuilder
      QUERY_DATE_FIELD = :created_at

      def self.selector(fm, ext_options = {})
        raise Exception.new("key time_params is not allowed to have a nil object as value!") if (ext_options.key?(:time_params) and ext_options[:time_params].nil?)

        options     = default_options.merge(ext_options)
        clasz       = options[:clasz]

        query = nil

        if( fm.get_plugin(Qaram::Plugin::MapReduce) || fm.get_plugin(Qaram::Plugin::DateTime) )
          query = clasz

          query = build_from_date_time(query, fm.get_plugin(Qaram::Plugin::DateTime), :time_params => options[:time_params])
          query = build_from_map_reduce(query, fm.get_plugin(Qaram::Plugin::MapReduce))
        end

        query = query.selector if query
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
          #from      = DateTime.parse(plugin.from.to_s).to_time.utc
          #till      = DateTime.parse(plugin.till.to_s).to_time.utc

          options[:time_params].each do |param|
            query = query.between((Marbu::MapReduceModel::DOCUMENT_OFFSET+param.to_s).to_sym, plugin.from, plugin.till)
          end
        end

        return query
      end

      def self.build_from_map_reduce(query, plugin, ext_options = {})
        options       = ext_options

        if( plugin && plugin.values )
          plugin.values.each do |value|
            att = (Marbu::MapReduceModel::DOCUMENT_OFFSET+value.key.to_s).to_sym

            if value.value.is_a?(Array)
             query = query.where(att.in => value.value)
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
