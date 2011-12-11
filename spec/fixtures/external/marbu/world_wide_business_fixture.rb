module Marbu
  module Test
    module Fixtures
      module Models
        module MapReduceFinalize
          MR_WWB_LOC_DIM0 = {
            :map => {
              :keys => [
                {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"}
              ],
              :values =>  [
                {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
                {:name => "count"}
              ],
              :code => {
                :text => 'count = 1;'
              }
            },

            :reduce => {
              :values =>  [
                {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
                {:name => "count"}
              ],
              :code => {
                :text =>  <<-JS
                            var count = 0;
                            values.forEach(function(v){
                              count += v.count;
                            });
                          JS
              }
            },

            :finalize => {
              :values => [
                {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
                {:name => "count",                :function => "value.count"}
              ]
            },

            :misc => {
              :database               => "qed_ruby_mongodb_test",
              :input_collection       => "world_wide_business",
              :output_collection      => "world_wide_business_mr_dim0",
            }
          }

          MR_WWB_LOC_DIM1 = {
            :map => {
              :keys => [
                {:name => "DIM_LOC_1",            :function => "value.DIM_LOC_1"}
              ],
              :values =>  [
                {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
                {:name => "DIM_LOC_1",            :function => "value.DIM_LOC_1"},
                {:name => "count"}
              ],
              :code => {
                :text => 'count = 1;'
              }
            },

            :reduce => {
              :values =>  [
                {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
                {:name => "DIM_LOC_1",            :function => "value.DIM_LOC_1"},
                {:name => "count"}
              ],
              :code => {
                :text =>  <<-JS
                            var count = 0;
                            values.forEach(function(v){
                              count += v.count;
                            });
                          JS
              }
            },

            :finalize => {
              :values => [
                {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
                {:name => "DIM_LOC_1",            :function => "value.DIM_LOC_1"},
                {:name => "count",                :function => "value.count"}
              ],
            },

            :misc => {
              :database           => "qed_ruby_mongodb_test",
              :input_collection   => "world_wide_business",
              :output_collection  => "world_wide_business_mr_dim1",
            }
          }

          MR_WWB_LOC_DIM2 = {
            :map => {
              :keys => [
                {:name => "DIM_LOC_2", :function => "value.DIM_LOC_2"}
              ],
              :values =>  [
                {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
                {:name => "DIM_LOC_1",            :function => "value.DIM_LOC_1"},
                {:name => "DIM_LOC_2",            :function => "value.DIM_LOC_2"},
                {:name => "count"}
              ],
              :code => {
                :text => 'count = 1;'
              }
            },

            :reduce => {
              :values =>  [
                {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
                {:name => "DIM_LOC_1",            :function => "value.DIM_LOC_1"},
                {:name => "DIM_LOC_2",            :function => "value.DIM_LOC_2"},
                {:name => "count"}
              ],
              :code => {
                :text =>  <<-JS
                            var count = 0;
                            values.forEach(function(v){
                              count += v.count;
                            });
                          JS
              }
            },

            :finalize => {
              :values => [
                {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
                {:name => "DIM_LOC_1",            :function => "value.DIM_LOC_1"},
                {:name => "DIM_LOC_2",            :function => "value.DIM_LOC_2"},
                {:name => "count",                :function => "value.count"}
              ],
            },

            :misc => {
              :database               => "qed_ruby_mongodb_test",
              :input_collection       => "world_wide_business",
              :output_collection      => "world_wide_business_mr_dim2",
            }
          }

          MR_WWB_LOC_DIM3 = {
            :map => {
              :keys => [
                {:name => "DIM_LOC_3", :function => "value.DIM_LOC_3"}
              ],
              :values =>  [
                {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
                {:name => "DIM_LOC_1",            :function => "value.DIM_LOC_1"},
                {:name => "DIM_LOC_2",            :function => "value.DIM_LOC_2"},
                {:name => "DIM_LOC_3",            :function => "value.DIM_LOC_3"},
                {:name => "count"}
              ],
              :code => {
                :text => 'count = 1;'
              }
            },

            :reduce => {
              :values =>  [
                {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
                {:name => "DIM_LOC_1",            :function => "value.DIM_LOC_1"},
                {:name => "DIM_LOC_2",            :function => "value.DIM_LOC_2"},
                {:name => "DIM_LOC_3",            :function => "value.DIM_LOC_3"},
                {:name => "count"}
              ],
              :code => {
                :text =>  <<-JS
                            var count = 0;
                            values.forEach(function(v){
                              count += v.count;
                            });
                          JS
              }
            },

            :finalize => {
              :values => [
                {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
                {:name => "DIM_LOC_1",            :function => "value.DIM_LOC_1"},
                {:name => "DIM_LOC_2",            :function => "value.DIM_LOC_2"},
                {:name => "DIM_LOC_3",            :function => "value.DIM_LOC_3"},
                {:name => "count",                :function => "value.count"}
              ],
            },

            :misc => {
              :database             => "qed_ruby_mongodb_test",
              :input_collection     => "world_wide_business",
              :output_collection    => "world_wide_business_mr_dim3",
            }
          }
        end
      end
    end
  end
end