module Qed
  module Mongodb
    class QueryBuilder
      def self.selector(fm, clasz = Qed::Mongodb::MongoidModel)
        cursor = clasz
        filter = fm.filter

        if filter.any?
          filter.each_pair do |k,v|
            att = (fm.offset+k.to_s).to_sym
            if v[fm.from_date] and v[fm.till_date]
              cursor = cursor.between(att, v[fm.from_date], v[fm.till_date])
            elsif v[fm.value].is_a?(Array)
              cursor = cursor.where(att.in => v[fm.value])
            else
              cursor = cursor.where(att.to_s => v[fm.value])
            end
          end
        end
        return cursor.selector
      end
    end
  end
end
