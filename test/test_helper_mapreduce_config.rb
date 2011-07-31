require 'config/test_config'

MAPREDUCE_CONFIG = {
    :test => {
      :scale_of_universe           =>  {
        # the order is important here, the first mapreduce will be done first, then the second and so on
        :mapreduce =>       [
                                MAPREDUCE_DIM4,
                                MAPREDUCE_DIM3,
                                MAPREDUCE_DIM2,
                                MAPREDUCE_DIM1,
                                MAPREDUCE_DIM0
                            ]
      },
      :query_only_scale_of_universe           =>  {
        # the order is important here, the first mapreduce will be done first, then the second and so on
        :mapreduce =>       [
                                MAPREDUCE_DIM4
                            ]
      }
    }
}

