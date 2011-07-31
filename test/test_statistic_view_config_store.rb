module Qed
  module Mongodb
    class StatisticViewConfigStore
      PROFILE = {
          :test => {
            :mapreduce_2            =>  {
              # the order is important here, the first mapreduce will be done first, then the second and so on
              :mapreduce =>       [
                                      Qed::Mongodb::MapReduce::Config::KP_CBP_1,
                                      Qed::Mongodb::MapReduce::Config::KP_CBC_2
                                  ]
            }
          }
        }

      def self.get_config(user, view)
        PROFILE[user.to_sym][view.to_sym]
      end
    end
  end
end
