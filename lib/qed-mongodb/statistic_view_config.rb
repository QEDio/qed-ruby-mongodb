module Qed
  module Mongodb
    class StatisticViewConfig
      # from the config create the necessary objects to perform all mapreduce operations which are needed to generate
      # the desired view/statistic
      def self.create_config(filter_model, config = Qed::Mongodb::StatisticViewConfigStore::PROFILE)
        raise Qed::Mongodb::Exceptions::FilterModelError.
          new("filter_model param is not a FilterModel-Object!") if !filter_model.is_a?(Qaram::FilterModel)
        raise Qed::Mongodb::Exceptions::FilterModelError.
          new("config param is not a hash!") if !config.is_a?(Hash)
        raise Qed::Mongodb::Exceptions::FilterModelError.
          new("variable user in filter_model is not allowed to be nil!") if filter_model.view.nil?
        raise Qed::Mongodb::Exceptions::FilterModelError.
          new("variable view in filter_model is not allowed to be nil!") if filter_model.user.nil?

        # get the mapreduce-configurations
        mapreduce_configurations = get_config(config, filter_model.user, filter_model.view)[:mapreduce]

        if mapreduce_configurations.nil?
          raise Qed::Mongodb::Exceptions::MapReduceConfigurationNotFound.
            new("Either the user: #{filter_model.user} or the view: #{filter_model.view} doesn't exist'")
        elsif !mapreduce_configurations.is_a?(Array)
          raise Qed::Mongodb::Exceptions::MapReduceConfigurationUnknownError.
            new("Excpected an array as return type, got #{mapreduce_configurations.class} for user: #{filter_model.user} and view: #{filter_model.view}")
        elsif mapreduce_configurations.size == 0
          raise Qed::Mongodb::Exceptions::MapReduceConfigurationNotFound.
            new("Couldn't get mapreduce configuration for user: #{filter_model.user} and view: #{filter_model.view}")
        end

        if( mapreduce_configurations.size > filter_model.drilldown_level_current)
          # only get those needed for the current drilldown level
          # TODO: I guess we have to rethink if a drilldown level of 0 is really the most reduced stats view
          # drilldown level == 0 is most reduced stats view
          # drilldown level == size of returned configuration is unreduced stats view (but almost certainly filtered!)
          mapreduce_configurations = mapreduce_configurations[0..mapreduce_configurations.size-(1+filter_model.drilldown_level_current)]

          [].tap do |arr|
            mapreduce_configurations.each_with_index do |int_config, i|
              # only first mapreduce needs this filter query
              # interestingly this is exactly the place to implement mapreduce caching


              options = {}
              if int_config[:time_params]
                puts "time_params #{int_config[:time_params]}"
                options.merge!({:time_params => int_config[:time_params]})
              end

              int_config[:query] = i == 0 ? Qed::Mongodb::QueryBuilder.selector(filter_model, {:clasz => Qed::Mongodb::MongoidModel}.merge(options)) : nil

              # set externally provided map emit keys
              arr << set_map_emit_keys(Marbu::MapReduceModel.new(int_config), filter_model)
            end
          end
        # don't mapreduce, just show the filtered data
        else
          int_config = mapreduce_configurations.first
          options = {}
          if  int_config[:time_params]
            puts "time_params #{int_config[:time_params]}"
            options.merge!({:time_params => int_config[:time_params]})
          end
          int_config[:query] = Qed::Mongodb::QueryBuilder.selector(filter_model, {:clasz => Qed::Mongodb::MongoidModel}.merge(options))

          mrm = Marbu::MapReduceModel.new(int_config)
          mrm.force_query = true
          [mrm]
        end
      end

      def self.set_map_emit_keys(mrm, fm)
        if fm.map_reduce_params.emit_keys.size > 0
          map_obj = mrm.map
          # first delete all currently defined emit keys, because we have some shinier ones
          map_obj.keys = []

          fm.map_reduce_params.emit_keys.each do |emit_key|
            map_obj.add_key(emit_key.key)
          end
        end
        mrm
      end

      def self.get_config(config, user, view)
        config[user.to_sym][view.to_sym] || {}
      end
    end
  end
end
