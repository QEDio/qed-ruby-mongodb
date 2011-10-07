module Qed
  module Test
    module MapReduce
      module Store
        module WorldWideBusiness
          MAP_WWB_DIM3 =
            <<-JS
              count = 1;
            JS

          REDUCE_WWB_DIM3 =
            <<-JS
              var count = 0;
              values.forEach(function(v){
                count += v.count;
              });
            JS

          FINALIZE_WWB_DIM3 =
            <<-JS
            JS

          MAP_WWB_DIM2 =
            <<-JS
              count = 1;
            JS

          REDUCE_WWB_DIM2 =
            <<-JS
              var count = 0;
              values.forEach(function(v){
                count += v.count;
              });
            JS

          FINALIZE_WWB_DIM2 =
            <<-JS
            JS

          MAP_WWB_DIM1 =
            <<-JS
              count = 1;
            JS

          REDUCE_WWB_DIM1 =
            <<-JS
              var count = 0;
              values.forEach(function(v){
                count += v.count;
              });
            JS

          FINALIZE_WWB_DIM1 =
            <<-JS
            JS

          MAP_WWB_DIM0 =
            <<-JS
              count = 1;
            JS

          REDUCE_WWB_DIM0 =
            <<-JS
              var count = 0;
              values.forEach(function(v){
                count += v.count;
              });
            JS

          FINALIZE_WWB_DIM0 =
            <<-JS
            JS
        end
      end
    end
  end
end