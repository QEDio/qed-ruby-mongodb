require 'config/test_config_scale_of_universe'
require 'config/test_config_world_wide_business'

MAPREDUCE_CONFIG = {
    :test => {
      :scale_of_universe           =>  {
        # the order is important here, the first mapreduce will be done first, then the second and so on
        :mapreduce =>       [
                                MR_SOU_DIM4,
                                MR_SOU_DIM3,
                                MR_SOU_DIM2,
                                MR_SOU_DIM1,
                                MR_SOU_DIM0
                            ]
      },
      :query_only_scale_of_universe           =>  {
        # the order is important here, the first mapreduce will be done first, then the second and so on
        :mapreduce =>       [
                                MR_SOU_DIM4
                            ]
      },

      :query_only_world_wide_business           =>  {
        # the order is important here, the first mapreduce will be done first, then the second and so on
        :mapreduce =>       [
                                MR_WWB_LOC_DIM0
                            ]
      },

      :world_wide_business           =>  {
        # the order is important here, the first mapreduce will be done first, then the second and so on
        :mapreduce =>       [
                                MR_WWB_LOC_DIM0,
                                MR_WWB_LOC_DIM1,
                                MR_WWB_LOC_DIM2
                            ]
      }


    }
}

