module Qed
  module Mongodb
    class QueryBuilder
      def self.selector(fm, clasz = Qed::Mongodb::MongoidModel)
        query = {}
        filter = fm.filter

        if (fm.created_at && fm.created_at[Qed::Filter::FilterModel::FROM_DATE] && fm.created_at[Qed::Filter::FilterModel::TILL_DATE]) || filter.any?
          query = clasz

          if fm.created_at && fm.created_at[Qed::Filter::FilterModel::FROM_DATE] && fm.created_at[Qed::Filter::FilterModel::TILL_DATE]
            query = query.between(((Marbu::MapReduceModel::DOCUMENT_OFFSET+Qed::Filter::FilterModel::CREATED_AT.to_s).to_sym), fm.created_at[Qed::Filter::FilterModel::FROM_DATE], fm.created_at[Qed::Filter::FilterModel::TILL_DATE])
          end

          if filter.any?
            filter.each_pair do |k,v|Qed::Mongodb::MongoidModel
              att = (Marbu::MapReduceModel::DOCUMENT_OFFSET+k.to_s).to_sym
              if v[Qed::Filter::FilterModel::VALUE].is_a?(Array)
                query = query.where(att.in => v[Qed::Filter::FilterModel::VALUE])
              else
                query = query.where(att.to_s => v[Qed::Filter::FilterModel::VALUE])
              end
            end
            query = query.selector
          end
        end

        return query
      end
    end
  end
end
