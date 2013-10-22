# -*- encoding: utf-8 -*-

module Qed
  module Mongodb
    class QueryBuilder
      def self.selector(fm, ext_options = {})
        options                   = default_options.merge(ext_options.delete_if{|k,v|v.nil?})
        klass                     = options[:klass]
        mapreduce_configuration   = options[:mapreduce_configuration]
        mr_id                     = mapreduce_configuration.misc.id rescue nil
        query                     = mapreduce_configuration.query
        klass                     = build_from_date_time(klass, fm.datetime, :datetime_fields => query.datetime_fields, :enforce_match => options[:enforce_match])
        klass                     = build_from_query(klass, fm.query, :mr_id => mr_id, :enforce_match => options[:enforce_match])
        klass                     = add_condition(klass, query.condition)

        if klass.is_a?(Qed::Mongodb::MongoidModel)
          klass = klass.selector
        else
          klass = nil
        end
        
        return klass
      end

      def self.default_options
        {
          :klass              => Qed::Mongodb::MongoidModel.new()
        }
      end

      def self.build_from_date_time(klass, plugin, ext_options = {})
        if ext_options[:enforce_match]
          options   = ext_options

          if plugin && plugin.from && plugin.till
            options[:datetime_fields].each do |datetime_field|
              klass = klass.between((Marbu::Models::Misc::DOCUMENT_OFFSET+datetime_field.to_s).to_sym => plugin.from..plugin.till)
            end
          end
        end

        return klass
      end

      def self.add_condition(query, conditions)
        if conditions.present?
          conditions.each do |condition|
            if condition[:op].present?
              query = query.where( condition[:field].to_sym.send(condition[:op].to_s) => condition[:value] )
            else
              if condition[:negative]
                #query = query.where(condition[:field].to_sym.not_in => condition[:value])
                query = query.not_in(condition[:field].to_sym => condition[:value])
              else
                query = query.where(condition[:field].to_sym.in => condition[:value])
              end
            end
          end
        end

        query
      end

      def self.build_from_query(query, plugin, ext_options = {})
        options         = ext_options
        mr_id           = options[:mr_id]
        enforce_match   = !!options[:enforce_match]

        if plugin && plugin.values
          plugin.values.each do |value|
            att, op, type = value.key.to_s.split('--')
            att, id       = att.split('__')
            att           = (Marbu::Models::Misc::DOCUMENT_OFFSET+att).to_sym

            if (id.blank? && enforce_match) || (id.present? && id.eql?(mr_id))
              if op.present?
                op, v               = convert_op(op, type, value)
                query               = query.send(op, {att => v})
              else
                if value.value.is_a?(Array) && value.value.size > 0
                  if value.value.size == 1
                    # check if regexp
                    if value.value[0][0] == '/' and value.value[0][-1] == '/'
                      value.value[0] = Regexp.new value.value[0][1..-2]
                    end
                    query = query.where(att.to_s => value.value[0])
                  else
                    query = query.where(att.in => value.value)
                  end
                else
                  if value.value[0] == '/' and value.value[-1] == '/'
                    value.value = Regexp.new value.value
                  end
                  query = query.where(att.to_s => value.value)
                end
              end
            end
          end
        end

        return query
      end

      def self.convert_op(op, type, value)
        return nil if op.blank?
        conv_op     = nil
        conv_value  = nil

        case op
          when 'gt' then
            type        ||= 'i'
            conv_op     = 'gt'
            conv_value  = convert_value(value, type)
          else raise "Unknown op: #{op}"
        end


        return conv_op, conv_value
      end

      def self.convert_value(value, type)
        case type
          when 'i' then value.value[0].to_i
          when 'f' then value.value[0].to_f
          else raise "Unknown type #{type} to convert to"
        end
      end

    end
  end
end
