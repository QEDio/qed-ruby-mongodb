module Qed
  module Mongodb
    class StatisticViewConfigStore
      PROFILE = {
          :kp => {
            :conversion_by_channel            => [ Qed::Mongodb::MapReduceConfig::KP_CBP_1, Qed::Mongodb::MapReduceConfig::KP_CBC_2 ],
            :conversion_by_product            => [ Qed::Mongodb::MapReduceConfig::KP_CBP_1, Qed::Mongodb::MapReduceConfig::KP_CBP_2 ],
            :topseller                        => [ Qed::Mongodb::MapReduceConfig::KP_CBP_1, Qed::Mongodb::MapReduceConfig::KP_CBP_2 ]
          }
        }

      def self.get_config(user, action)
        PROFILE[user][action]
      end
    end
  end
end
