# -*- encoding: utf-8 -*-
module Qed
  module Mongodb
    class QueryBuilder
      def self.selector(fm, ext_options = {})
        options     = default_options.merge(ext_options.delete_if{|k,v|v.nil?})
        klass       = options[:klass]
        query       = options[:query]

        klass       = build_from_date_time(klass, fm.datetime, :datetime_fields => query.datetime_fields)
        klass       = build_from_query(klass, fm.query)

        if( klass.is_a?(Mongoid::Criteria) )
          klass = klass.selector
        else
          klass = nil
        end
        
        return klass
      end

      def self.default_options
        {
          :klass              => Qed::Mongodb::MongoidModel
        }
      end

      def self.build_from_date_time(klass, plugin, ext_options = {})
        options   = ext_options

        if( plugin && plugin.from && plugin.till )
          options[:datetime_fields].each do |datetime_field|
            klass = klass.between((Marbu::Models::Misc::DOCUMENT_OFFSET+datetime_field.to_s).to_sym, plugin.from, plugin.till)
          end
        end

        return klass
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
