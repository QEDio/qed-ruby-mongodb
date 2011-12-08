module Qed
  module Test
    module StatisticViewConfigStore            
      MAPREDUCE_CONFIG = {
        :test => {
          :scale_of_universe =>  {
            # the order is important here, the first mapreduce will be done first, then the second and so on
            :mapreduce => [
              Marbu::Test::Models::MapReduceFinalize::MR_SOU_DIM4
              #MR_SOU_DIM3,
              #MR_SOU_DIM2,
              #MR_SOU_DIM1,
              #MR_SOU_DIM0
            ]
          },
          :query_only_scale_of_universe =>  {
            # the order is important here, the first mapreduce will be done first, then the second and so on
            :mapreduce => [
              Marbu::Test::Models::MapReduceFinalize::MR_SOU_DIM4
            ]
          },

          :query_only_world_wide_business =>  {
            # the order is important here, the first mapreduce will be done first, then the second and so on
            :mapreduce => [
              Marbu::Test::Models::MapReduceFinalize::MR_WWB_LOC_DIM0
            ]
          },

          :world_wide_business_loc_dim0 =>  {
            # the order is important here, the first mapreduce will be done first, then the second and so on
            :mapreduce => [
              Marbu::Test::Models::MapReduceFinalize::MR_WWB_LOC_DIM0,
            ]
          },

          :world_wide_business_loc_dim1 => {
            :mapreduce => [
              Marbu::Test::Models::MapReduceFinalize::MR_WWB_LOC_DIM1
            ]
          },

          :world_wide_business_loc_dim2 => {
            :mapreduce => [
              Marbu::Test::Models::MapReduceFinalize::MR_WWB_LOC_DIM2
            ]
          },

          :world_wide_business_loc_dim3 => {
            :mapreduce => [
              Marbu::Test::Models::MapReduceFinalize::MR_WWB_LOC_DIM3
            ]
          }
        }
      }
    end
  end
end

