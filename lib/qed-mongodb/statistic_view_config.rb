module Qed
  module Mongodb
    class StatisticViewConfig
      # from the config create the necessary objects to perform all mapreduce operations which are needed to generate
      # the desired view/statistic
      def self.create_config(filter_model, config = Qed::Mongodb::StatisticViewConfigStore::PROFILE)
        raise Qed::Mongodb::Exceptions::FilterModelError.new("filter_model param ist not a FilterModel-Object!") if !filter_model.is_a?(Qed::Mongodb::FilterModel)
        raise Qed::Mongodb::Exceptions::FilterModelError.new("config param ist not a hash!") if !config.is_a?(Hash)



        # get the mapreduce-configurations
        mapreduce_configurations = get_config(config, filter_model.user, filter_model.view)[:mapreduce]

        if( mapreduce_configurations.size > filter_model.drilldown_level_current)
          # only get those needed for the current drilldown level
          # drilldown level == 0 is most reduced stats view
          # drilldown level == size of returned configuration is unreduced stats view (but almost certainly filtered!)
          mapreduce_configurations = mapreduce_configurations[0..mapreduce_configurations.size-(1+filter_model.drilldown_level_current)]

          [].tap do |arr|
            mapreduce_configurations.each_with_index do |config, i|
              # only first mapreduce needs this filter query
              config[:query] = i == 0 ? filter_model.mongodb_query : nil

              arr << Qed::Mongodb::MapReduce::Builder.new(config)
            end
          end
        # don't mapreduce, just show the filtered data
        else
          builder = Qed::Mongodb::MapReduce::Builder.new({:query => filter_model.mongodb_query })
          builder.database = mapreduce_configurations[0][:database]
          [builder]
        end
      end

      def self.get_config(config, user, view)
        config[user.to_sym][view.to_sym]
      end
    end
  end
end
