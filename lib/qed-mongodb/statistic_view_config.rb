module Qed
  module Mongodb
    class StatisticViewConfig
      def self.create_config(user, action, fm, level)
        config = Qed::Mongodb::StatisticViewConfigStore.get_config(user, action)[level]
        config[:query] = fm.mongodb_query
        Qed::Mongodb::MapReduce::Builder.new(config)
      end
    end
  end
end
