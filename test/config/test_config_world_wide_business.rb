require 'config/test_store_world_wide_business'

WWB_BASE_COLLECTION     =   "world_wide_business"

MR_WWB_LOC_DIM0 =
            {
                :mapreduce_keys => [
                    {:name => "DIM_LOC_0", :function => "value.DIM_LOC_0"}
                  ],
                :mapreduce_values =>  [
                    {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
                    {:name => "count"}
                  ],
                :finalize_values => [
                    {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
                    {:name => "count",                :function => "value.count"}
                ],
                :database             => "qed_ruby_mongodb_test",
                :base_collection      => WWB_BASE_COLLECTION,
                :mr_collection        => "#{WWB_BASE_COLLECTION}_mr_dim0",
                :query                => nil,
                :map                  => MAP_WWB_DIM0,
                :reduce               => REDUCE_WWB_DIM0,
                :finalize             => FINALIZE_WWB_DIM0
            }

MR_WWB_LOC_DIM1 =
            {
                :mapreduce_keys => [
                    {:name => "DIM_LOC_1", :function => "value.DIM_LOC_1"}
                  ],
                :mapreduce_values =>  [
                    {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
                    {:name => "DIM_LOC_1",            :function => "value.DIM_LOC_1"},
                    {:name => "count"}
                  ],
                :finalize_values => [
                    {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
                    {:name => "DIM_LOC_1",            :function => "value.DIM_LOC_1"},
                    {:name => "count",                :function => "value.count"}
                ],
                :database             => "qed_ruby_mongodb_test",
                :base_collection      => WWB_BASE_COLLECTION,
                :mr_collection        => "#{WWB_BASE_COLLECTION}_mr_dim1",
                :query      => nil,
                :map        => MAP_WWB_DIM1,
                :reduce     => REDUCE_WWB_DIM1,
                :finalize   => FINALIZE_WWB_DIM1
            }

MR_WWB_LOC_DIM2 =
            {
                :mapreduce_keys => [
                    {:name => "DIM_LOC_2", :function => "value.DIM_LOC_2"}
                  ],
                :mapreduce_values =>  [
                    {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
                    {:name => "DIM_LOC_1",            :function => "value.DIM_LOC_1"},
                    {:name => "DIM_LOC_2",            :function => "value.DIM_LOC_2"},
                    {:name => "count"}
                  ],
                :finalize_values => [
                    {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
                    {:name => "DIM_LOC_1",            :function => "value.DIM_LOC_1"},
                    {:name => "DIM_LOC_2",            :function => "value.DIM_LOC_2"},
                    {:name => "count",                :function => "value.count"}
                ],
                :database             => "qed_ruby_mongodb_test",
                :base_collection      => WWB_BASE_COLLECTION,
                :mr_collection        => "#{WWB_BASE_COLLECTION}_mr_dim2",
                :query      => nil,
                :map        => MAP_WWB_DIM2,
                :reduce     => REDUCE_WWB_DIM2,
                :finalize   => FINALIZE_WWB_DIM2
            }

MR_WWB_LOC_DIM3 =
            {
                :mapreduce_keys => [
                    {:name => "DIM_LOC_3", :function => "value.DIM_LOC_3"}
                  ],
                :mapreduce_values =>  [
                    {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
                    {:name => "DIM_LOC_1",            :function => "value.DIM_LOC_1"},
                    {:name => "DIM_LOC_2",            :function => "value.DIM_LOC_2"},
                    {:name => "DIM_LOC_3",            :function => "value.DIM_LOC_3"},
                    {:name => "count"}
                  ],
                :finalize_values => [
                    {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
                    {:name => "DIM_LOC_1",            :function => "value.DIM_LOC_1"},
                    {:name => "DIM_LOC_2",            :function => "value.DIM_LOC_2"},
                    {:name => "DIM_LOC_3",            :function => "value.DIM_LOC_3"},
                    {:name => "count",                :function => "value.count"}
                ],
                :database             => "qed_ruby_mongodb_test",
                :base_collection      => WWB_BASE_COLLECTION,
                :mr_collection        => "#{WWB_BASE_COLLECTION}_mr_dim3",
                :query      => nil,
                :map        => MAP_WWB_DIM3,
                :reduce     => REDUCE_WWB_DIM3,
                :finalize   => FINALIZE_WWB_DIM3
            }