# -*- encoding: utf-8 -*-
module Qed
  module Mongodb
    class StatisticViewConfig
      # from the config create the necessary objects to perform all mapreduce operations which are needed to generate
      # the desired view/statistic
      def self.create_config(filter_model, config = Qed::Mongodb::StatisticViewConfigStore::PROFILE)
        raise Qed::Mongodb::Exceptions::FilterModelError.
          new('filter_model param is not a FilterModel-Object!') if !filter_model.is_a?(Qstate::FilterModel)
        raise Qed::Mongodb::Exceptions::FilterModelError.
          new('config param is not a hash!') if !config.is_a?(Hash)
        raise Qed::Mongodb::Exceptions::FilterModelError.
          new('variable user in filter_model is not allowed to be nil!') if filter_model.view.view.nil?
        raise Qed::Mongodb::Exceptions::FilterModelError.
          new('variable view in filter_model is not allowed to be nil!') if filter_model.confidential.user.nil?

        # get the mapreduce-configurations
        mapreduce_configurations = get_mapreduce_config(config, filter_model)

        mapreduce_configurations.each_with_index do |mapreduce_configuration, i|
          # build query, do it:
          # ALWAYS for the first mapreduce configuration
          # for every other configuration that has misc.filter_data == true
          if i == 0 || mapreduce_configuration.misc.filter_data
            mapreduce_configuration.query.condition =
              Qed::Mongodb::QueryBuilder.selector(filter_model, :query => mapreduce_configuration.query )
          end

          set_map_emit_keys(mapreduce_configuration, filter_model)
        end

        return mapreduce_configurations
      end

      def self.set_map_emit_keys(mrm, fm)
        # legacy                                                      mapreduceaggregation
        #mrm = set_map_emit_keys_legacy(mrm,fm)

        # pimped version
        if fm.mapreduceaggregation.values.size > 0
          # do we have params for this mr-id?
          map_reduce_aggregation_keys = fm.mapreduceaggregation.values.select{|key_value|key_value.key.eql?(mrm.misc.id.to_sym)}.first

          if map_reduce_aggregation_keys.present?
            map_obj = mrm.map
            # first delete all currently defined emit keys, because we have some shinier ones
            map_obj.keys = []

            map_reduce_aggregation_keys.value.each do |emit_key|
              map_obj.add_key(emit_key.to_s)
            end
          end
        end

        mrm
      end

      #def self.set_map_emit_keys_legacy(mrm,fm)
      #  if fm.mapreduce.values.size > 0
      #    map_obj = mrm.map
      #    # first delete all currently defined emit keys, because we have some shinier ones
      #    map_obj.keys = []
      #
      #    fm.mapreduce.values.each do |emit_key|
      #      map_obj.add_key(emit_key.key)
      #    end
      #  end
      #  mrm
      #end

      # Todo: this is a bad shortcut, but for now I just need it to work
      def self.get_config(config, filter_model)
        #puts "FilterModel: #{filter_model.inspect}"
        raise Exception.new('filter_model has no user! This is not allowed') if filter_model.confidential.user.nil?
        user = filter_model.confidential.user.to_sym

        if filter_model.view.view.nil? && filter_model.view.action.nil?
          raise Exception.new('filter_model view and action are both nil! This is not allowed!')
        end

        raise Exception.new("Unknown user #{user}") unless config.key?(user)

        if filter_model.view.view && config[user.to_sym].key?(filter_model.view.view.to_sym)
          accessor = filter_model.view.view.to_sym
        else
          accessor = filter_model.view.action.to_sym
        end

        config[user][accessor] || {}
      end

      def self.get_mapreduce_config(config, filter_model)
        mapreduce_configurations = get_config(config, filter_model)[:mapreduce]

        if mapreduce_configurations.nil?
          raise Qed::Mongodb::Exceptions::MapReduceConfigurationNotFound.
            new("Either the user: #{filter_model.confidential.user} or the view: #{filter_model.view.view} doesn't exist'")
        elsif !mapreduce_configurations.is_a?(Array)
          raise Qed::Mongodb::Exceptions::MapReduceConfigurationUnknownError.
            new("Excpected an array as return type, got #{mapreduce_configurations.class} for user: #{filter_model.confidential.user} and view: #{filter_model.view.view}")
        elsif mapreduce_configurations.size == 0
          raise Qed::Mongodb::Exceptions::MapReduceConfigurationNotFound.
            new("Couldn't get mapreduce configuration for user: #{filter_model.confidential.user} and view: #{filter_model.view.view}")
        end

        mapreduce_configurations.collect{|c|Marbu::Models::MapReduceFinalize.new(c)}
      end
    end
  end
end
