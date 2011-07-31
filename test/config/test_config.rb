require 'config/test_store'

MAPREDUCE_DIM4 =
            {
                :key => {:name => "dim_4", :function => "value.dim_4"},
                :mapreduce_values =>  [
                    {:name => "dim_0",                :function => "value.dim_0"},
                    {:name => "dim_1",                :function => "value.dim_1"},
                    {:name => "dim_2",                :function => "value.dim_2"},
                    {:name => "dim_3",                :function => "value.dim_3"},
                    {:name => "dim_4",                :function => "value.dim_4"},
                    {:name => "length",               :function => "value.length"},
                    {:name => "width",                :function => "value.width"},
                    {:name => "count"}
                  ],
                :finalize_values => [
                    {:name => "dim_0",                :function => "value.dim_0"},
                    {:name => "dim_1",                :function => "value.dim_1"},
                    {:name => "dim_2",                :function => "value.dim_2"},
                    {:name => "dim_3",                :function => "value.dim_3"},
                    {:name => "dim_4",                :function => "value.dim_4"},
                    {:name => "length",               :function => "value.length"},
                    {:name => "width",                :function => "value.width"},
                    {:name => "count",                :function => "value.count"}
                ],
                :database             => "qed_test",
                :base_collection      => "scale_of_universe",
                :mr_collection        => "mr_dim4",
                :query                => nil,
                :map                  => MAP_DIM4,
                :reduce               => REDUCE_DIM4,
                :finalize             => FINALIZE_DIM4
            }

MAPREDUCE_DIM3 =
            {
                :key => {:name => "dim_3", :function => "value.dim_3"},
                :mapreduce_values =>  [
                    {:name => "dim_0",                :function => "value.dim_0"},
                    {:name => "dim_1",                :function => "value.dim_1"},
                    {:name => "dim_2",                :function => "value.dim_2"},
                    {:name => "dim_3",                :function => "value.dim_3"},
                    {:name => "dim_4",                :function => "value.dim_4"},
                    {:name => "length",               :function => "value.length"},
                    {:name => "width",                :function => "value.width"}
                  ],
                :finalize_values => [
                    {:name => "dim_0",                :function => "value.dim_0"},
                    {:name => "dim_1",                :function => "value.dim_1"},
                    {:name => "dim_2",                :function => "value.dim_2"},
                    {:name => "dim_3",                :function => "value.dim_3"},
                    {:name => "dim_4",                :function => "value.dim_4"},
                    {:name => "length",               :function => "value.length"},
                    {:name => "width",                :function => "value.width"}
                ],
                :database             => "qed_test",
                :base_collection      => "mr_dim4",
                :mr_collection        => "mr_dim3",
                :query      => nil,
                :map        => MAP_DIM3,
                :reduce     => REDUCE_DIM3,
                :finalize   => FINALIZE_DIM3
            }

MAPREDUCE_DIM2 =
            {
                :key => {:name => "dim_2", :function => "value.dim_2"},
                :mapreduce_values =>  [
                    {:name => "dim_0",                :function => "value.dim_0"},
                    {:name => "dim_1",                :function => "value.dim_1"},
                    {:name => "dim_2",                :function => "value.dim_2"},
                    {:name => "dim_3",                :function => "value.dim_3"},
                    {:name => "dim_4",                :function => "value.dim_4"},
                    {:name => "length",               :function => "value.length"},
                    {:name => "width",                :function => "value.width"}
                  ],
                :finalize_values => [
                    {:name => "dim_0",                :function => "value.dim_0"},
                    {:name => "dim_1",                :function => "value.dim_1"},
                    {:name => "dim_2",                :function => "value.dim_2"},
                    {:name => "dim_3",                :function => "value.dim_3"},
                    {:name => "dim_4",                :function => "value.dim_4"},
                    {:name => "length",               :function => "value.length"},
                    {:name => "width",                :function => "value.width"}
                ],
                :database             => "qed_test",
                :base_collection      => "mr_dim3",
                :mr_collection        => "mr_dim2",
                :query      => nil,
                :map        => MAP_DIM2,
                :reduce     => REDUCE_DIM2,
                :finalize   => FINALIZE_DIM2
            }

MAPREDUCE_DIM1 =
            {
                :key => {:name => "dim_1", :function => "value.dim_0"},
                :mapreduce_values =>  [
                    {:name => "dim_0",                :function => "value.dim_0"},
                    {:name => "dim_1",                :function => "value.dim_1"},
                    {:name => "dim_2",                :function => "value.dim_2"},
                    {:name => "dim_3",                :function => "value.dim_3"},
                    {:name => "dim_4",                :function => "value.dim_4"},
                    {:name => "length",               :function => "value.length"},
                    {:name => "width",                :function => "value.width"}
                  ],
                :finalize_values => [
                    {:name => "dim_0",                :function => "value.dim_0"},
                    {:name => "dim_1",                :function => "value.dim_1"},
                    {:name => "dim_2",                :function => "value.dim_2"},
                    {:name => "dim_3",                :function => "value.dim_3"},
                    {:name => "dim_4",                :function => "value.dim_4"},
                    {:name => "length",               :function => "value.length"},
                    {:name => "width",                :function => "value.width"}
                ],
                :database             => "qed_test",
                :base_collection      => "mr_dim2",
                :mr_collection        => "mr_dim1",
                :query      => nil,
                :map        => MAP_DIM1,
                :reduce     => REDUCE_DIM1,
                :finalize   => FINALIZE_DIM1
            }

MAPREDUCE_DIM0 =
            {
                :key => {:name => "dim_0", :function => "value.dim_0"},
                :mapreduce_values =>  [
                    {:name => "dim_0",                :function => "value.dim_0"},
                    {:name => "dim_1",                :function => "value.dim_1"},
                    {:name => "dim_2",                :function => "value.dim_2"},
                    {:name => "dim_3",                :function => "value.dim_3"},
                    {:name => "dim_4",                :function => "value.dim_4"},
                    {:name => "length",               :function => "value.length"},
                    {:name => "width",                :function => "value.width"}
                  ],
                :finalize_values => [
                    {:name => "dim_0",                :function => "value.dim_0"},
                    {:name => "dim_1",                :function => "value.dim_1"},
                    {:name => "dim_2",                :function => "value.dim_2"},
                    {:name => "dim_3",                :function => "value.dim_3"},
                    {:name => "dim_4",                :function => "value.dim_4"},
                    {:name => "length",               :function => "value.length"},
                    {:name => "width",                :function => "value.width"}
                ],
                :database             => "qed_test",
                :base_collection      => "mr_dim1",
                :mr_collection        => "mr_dim0",
                :query      => nil,
                :map        => MAP_DIM0,
                :reduce     => REDUCE_DIM0,
                :finalize   => FINALIZE_DIM0
            }