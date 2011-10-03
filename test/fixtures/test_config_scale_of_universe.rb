require 'fixtures/test_store_scale_of_universe'

MR_SOU_DIM4 =
            {
                :mapreduce_keys => [
                    {:name => "dim_4", :function => "value.dim_4"}
                  ],
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
                :database             => "qed_ruby_mongodb_test",
                :base_collection      => "scale_of_universe",
                :mr_collection        => "mr_dim4",
                :query                => nil,
                :map                  => MAP_SOU_DIM4,
                :reduce               => REDUCE_SOU_DIM4,
                :finalize             => FINALIZE_SOU_DIM4
            }

MR_SOU_DIM3 =
            {
                :mapreduce_keys => [
                    {:name => "dim_3", :function => "value.dim_3"}
                  ],
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
                :database             => "qed_ruby_mongodb_test",
                :base_collection      => "mr_dim4",
                :mr_collection        => "mr_dim3",
                :query      => nil,
                :map        => MAP_SOU_DIM3,
                :reduce     => REDUCE_SOU_DIM3,
                :finalize   => FINALIZE_SOU_DIM3
            }

MR_SOU_DIM2 =
            {
                :mapreduce_keys => [
                    {:name => "dim_2", :function => "value.dim_2"}
                  ],
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
                :database             => "qed_ruby_mongodb_test",
                :base_collection      => "mr_dim3",
                :mr_collection        => "mr_dim2",
                :query      => nil,
                :map        => MAP_SOU_DIM2,
                :reduce     => REDUCE_SOU_DIM2,
                :finalize   => FINALIZE_SOU_DIM2
            }

MR_SOU_DIM1 =
            {
                :mapreduce_keys => [
                    {:name => "dim_1", :function => "value.dim_0"}
                  ],
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
                :database             => "qed_ruby_mongodb_test",
                :base_collection      => "mr_dim2",
                :mr_collection        => "mr_dim1",
                :query      => nil,
                :map        => MAP_SOU_DIM1,
                :reduce     => REDUCE_SOU_DIM1,
                :finalize   => FINALIZE_SOU_DIM1
            }

MR_SOU_DIM0 =
            {
                :mapreduce_keys => [
                    {:name => "dim_0", :function => "value.dim_0"}
                  ],
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
                :database             => "qed_ruby_mongodb_test",
                :base_collection      => "mr_dim1",
                :mr_collection        => "mr_dim0",
                :query      => nil,
                :map        => MAP_SOU_DIM0,
                :reduce     => REDUCE_SOU_DIM0,
                :finalize   => FINALIZE_SOU_DIM0
            }