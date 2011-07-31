MAP_DIM4 =
  <<-JS
    count = 1;
  JS

REDUCE_DIM4 =
  <<-JS
    var count = 0;
    values.forEach(function(v){
      count += v.count;
    });
  JS

FINALIZE_DIM4=
  <<-JS
  JS


MAP_DIM3 =
  <<-JS
  JS

REDUCE_DIM3 =
  <<-JS
  JS

FINALIZE_DIM3 =
  <<-JS
  JS

MAP_DIM2 =
  <<-JS
  JS

REDUCE_DIM2 =
  <<-JS
  JS

FINALIZE_DIM2 =
  <<-JS
  JS

MAP_DIM1 =
  <<-JS
  JS

REDUCE_DIM1 =
  <<-JS
  JS

FINALIZE_DIM1 =
  <<-JS
  JS

MAP_DIM0 =
  <<-JS
  JS

REDUCE_DIM0 =
  <<-JS
  JS

FINALIZE_DIM0 =
  <<-JS
  JS