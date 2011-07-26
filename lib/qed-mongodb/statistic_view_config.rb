module Qed
  module Mongodb
    class StatisticViewConfig
      def self.create_config(fm, level)
        config = Qed::Mongodb::StatisticViewConfigStore.get_config(fm.user, fm.view)[level]
        config[:query] = fm.mongodb_query
        Qed::Mongodb::MapReduce::Builder.new(config)
      end
    end
  end
end
