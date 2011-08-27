module Qed
  module Mongodb
    class QueryBuilder
      QUERY_DATE_FIELD = :created_at

      def self.selector(fm, options = {})
        raise Exception.new("key time_params is not allowed to have a nil object as value!") if (options.key?(:time_params) and options[:time_params].nil?)

        int_options = internal_options.merge(options)
        clasz       = int_options[:clasz]

        query = nil
        filter = fm.filter

        if (fm.created_at && fm.created_at[Qed::Filter::FilterModel::FROM_DATE] && fm.created_at[Qed::Filter::FilterModel::TILL_DATE]) || filter.any?
          query = clasz

          query = build_date(query, int_options[:time_params], fm.created_at[Qed::Filter::FilterModel::FROM_DATE], fm.created_at[Qed::Filter::FilterModel::TILL_DATE])
          query = build_others(query, fm)
        end

        query = query.selector if query
        return query
      end

      def self.build_date(query, time_params, from, till)
        time_params.each do |param|
          query = query.between(("value."+param.to_s).to_sym, from, till)
        end

        query
      end

      def self.build_others(query, fm)
        filter = fm.filter
        if filter.any?
          filter.each_pair do |k,v|
            att = (Marbu::MapReduceModel::DOCUMENT_OFFSET+k.to_s).to_sym
            if v[Qed::Filter::FilterModel::VALUE].is_a?(Array)
              query = query.where(att.in => v[Qed::Filter::FilterModel::VALUE])
            else
              query = query.where(att.to_s => v[Qed::Filter::FilterModel::VALUE])
            end
          end
        end
        query
      end

      def self.internal_options
        {
            :time_params        => [QUERY_DATE_FIELD],
            :clasz              => Qed::Mongodb::MongoidModel
        }
      end


    end
  end
end
