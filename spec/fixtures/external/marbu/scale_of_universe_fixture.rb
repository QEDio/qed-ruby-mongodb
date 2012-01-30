# -*- encoding: utf-8 -*-
module Marbu
  module Test
    module Fixtures
      module Models
        module MapReduceFinalize
          MR_SOU_DIM4 = {
            :map => {
              :keys => [
                {:name => "dim_4", :function => "value.dim_4"}
              ],
              :values =>  [
                {:name => "dim_0",                :function => "value.dim_0"},
                {:name => "dim_1",                :function => "value.dim_1"},
                {:name => "dim_2",                :function => "value.dim_2"},
                {:name => "dim_3",                :function => "value.dim_3"},
                {:name => "dim_4",                :function => "value.dim_4"},
                {:name => "length",               :function => "value.length"},
                {:name => "width",                :function => "value.width"},
                {:name => "count"}
              ],
              :code => {
                :text =>  'count = 1;'
              }
            },

            :reduce => {
              :keys => [
                {:name => "dim_4", :function => "value.dim_4"}
              ],
              :values =>  [
                {:name => "dim_0",                :function => "value.dim_0"},
                {:name => "dim_1",                :function => "value.dim_1"},
                {:name => "dim_2",                :function => "value.dim_2"},
                {:name => "dim_3",                :function => "value.dim_3"},
                {:name => "dim_4",                :function => "value.dim_4"},
                {:name => "length",               :function => "value.length"},
                {:name => "width",                :function => "value.width"},
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
              :keys => [
                {:name => "dim_4", :function => "value.dim_4"}
              ],
              :values =>  [
                {:name => "dim_0",                :function => "value.dim_0"},
                {:name => "dim_1",                :function => "value.dim_1"},
                {:name => "dim_2",                :function => "value.dim_2"},
                {:name => "dim_3",                :function => "value.dim_3"},
                {:name => "dim_4",                :function => "value.dim_4"},
                {:name => "length",               :function => "value.length"},
                {:name => "width",                :function => "value.width"},
                {:name => "count",                :function => "value.count"}
              ],
              :code => {
                :text => ''
              }
            },

            :misc => {
              :database               => 'qed_ruby_mongodb_test',
              :input_collection       => 'scale_of_universe',
              :output_collection      => "mr_dim4",
            }
          }

          MR_SOU_DIM3 = {
            :map => {
              :keys => [
                {:name => "dim_3", :function => "value.dim_3"}
              ],
              :values =>  [
                {:name => "dim_0",                :function => "value.dim_0"},
                {:name => "dim_1",                :function => "value.dim_1"},
                {:name => "dim_2",                :function => "value.dim_2"},
                {:name => "dim_3",                :function => "value.dim_3"},
                {:name => "dim_4",                :function => "value.dim_4"},
                {:name => "length",               :function => "value.length"},
                {:name => "width",                :function => "value.width"}
              ]
            },

            :finalize => {
              :values => [
                {:name => "dim_0",                :function => "value.dim_0"},
                {:name => "dim_1",                :function => "value.dim_1"},
                {:name => "dim_2",                :function => "value.dim_2"},
                {:name => "dim_3",                :function => "value.dim_3"},
                {:name => "dim_4",                :function => "value.dim_4"},
                {:name => "length",               :function => "value.length"},
                {:name => "width",                :function => "value.width"}
              ]
            },

            :misc => {
              :database             => "qed_ruby_mongodb_test",
              :input_collection      => "mr_dim4",
              :outpu_collection        => "mr_dim3",
            }
          }

          MR_SOU_DIM2 = {
            :map => {
              :keys => [
                {:name => "dim_2", :function => "value.dim_2"}
              ],
              :values =>  [
                {:name => "dim_0",                :function => "value.dim_0"},
                {:name => "dim_1",                :function => "value.dim_1"},
                {:name => "dim_2",                :function => "value.dim_2"},
                {:name => "dim_3",                :function => "value.dim_3"},
                {:name => "dim_4",                :function => "value.dim_4"},
                {:name => "length",               :function => "value.length"},
                {:name => "width",                :function => "value.width"}
              ]
            },

            :finalize => {
              :values => [
                {:name => "dim_0",                :function => "value.dim_0"},
                {:name => "dim_1",                :function => "value.dim_1"},
                {:name => "dim_2",                :function => "value.dim_2"},
                {:name => "dim_3",                :function => "value.dim_3"},
                {:name => "dim_4",                :function => "value.dim_4"},
                {:name => "length",               :function => "value.length"},
                {:name => "width",                :function => "value.width"}
              ]
            },

            :misc => {
              :database               => "qed_ruby_mongodb_test",
              :input_collection       => "mr_dim3",
              :output_collection      => "mr_dim2",
            }
          }

          MR_SOU_DIM1 = {
            :map => {
              :keys => [
                {:name => "dim_1", :function => "value.dim_0"}
              ],
              :values =>  [
                {:name => "dim_0",                :function => "value.dim_0"},
                {:name => "dim_1",                :function => "value.dim_1"},
                {:name => "dim_2",                :function => "value.dim_2"},
                {:name => "dim_3",                :function => "value.dim_3"},
                {:name => "dim_4",                :function => "value.dim_4"},
                {:name => "length",               :function => "value.length"},
                {:name => "width",                :function => "value.width"}
              ]
            },

            :finalize => {
              :values => [
                {:name => "dim_0",                :function => "value.dim_0"},
                {:name => "dim_1",                :function => "value.dim_1"},
                {:name => "dim_2",                :function => "value.dim_2"},
                {:name => "dim_3",                :function => "value.dim_3"},
                {:name => "dim_4",                :function => "value.dim_4"},
                {:name => "length",               :function => "value.length"},
                {:name => "width",                :function => "value.width"}
              ]
            },

            :misc => {
              :database               => "qed_ruby_mongodb_test",
              :input_collection       => "mr_dim2",
              :output_collection       => "mr_dim1",
            }
          }

          MR_SOU_DIM0 = {
            :map => {
              :keys => [
                {:name => "dim_0", :function => "value.dim_0"}
              ],
              :values =>  [
                {:name => "dim_0",                :function => "value.dim_0"},
                {:name => "dim_1",                :function => "value.dim_1"},
                {:name => "dim_2",                :function => "value.dim_2"},
                {:name => "dim_3",                :function => "value.dim_3"},
                {:name => "dim_4",                :function => "value.dim_4"},
                {:name => "length",               :function => "value.length"},
                {:name => "width",                :function => "value.width"}
              ]
            },

            :finalize => {
              :values => [
                {:name => "dim_0",                :function => "value.dim_0"},
                {:name => "dim_1",                :function => "value.dim_1"},
                {:name => "dim_2",                :function => "value.dim_2"},
                {:name => "dim_3",                :function => "value.dim_3"},
                {:name => "dim_4",                :function => "value.dim_4"},
                {:name => "length",               :function => "value.length"},
                {:name => "width",                :function => "value.width"}
              ]
            },

            :misc => {
              :database             => "qed_ruby_mongodb_test",
              :input_collection     => "mr_dim1",
              :output_collection    => "mr_dim0",
            }
          }
        end
      end
    end
  end
end