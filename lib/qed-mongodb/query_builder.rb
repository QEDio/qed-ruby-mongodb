module Qed
  module Mongodb
    class QueryBuilder
      def self.selector(fm, clasz = Qed::Mongodb::MongoidModel)
        cursor = clasz
        filter = fm.filter

        if filter.any?
          filter.each_pair do |k,v|
            att = (Qed::Mongodb::FilterModel::DOCUMENT_OFFSET+k.to_s).to_sym
            if v[Qed::Mongodb::FilterModel::FROM_DATE] and v[Qed::Mongodb::FilterModel::TILL_DATE]
              cursor = cursor.between(att, v[Qed::Mongodb::FilterModel::FROM_DATE], v[Qed::Mongodb::FilterModel::TILL_DATE])
            elsif v[Qed::Mongodb::FilterModel::VALUE].is_a?(Array)
              cursor = cursor.where(att.in => v[Qed::Mongodb::FilterModel::VALUE])
            else
              cursor = cursor.where(att.to_s => v[Qed::Mongodb::FilterModel::VALUE])
            end
          end
        end
        return cursor.selector
      end
    end
  end
end
