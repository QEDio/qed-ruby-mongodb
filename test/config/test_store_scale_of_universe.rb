MAP_SOU_DIM4 =
  <<-JS
    count = 1;
  JS

REDUCE_SOU_DIM4 =
  <<-JS
    var count = 0;
    values.forEach(function(v){
      count += v.count;
    });
  JS

FINALIZE_SOU_DIM4=
  <<-JS
  JS


MAP_SOU_DIM3 =
  <<-JS
  JS

REDUCE_SOU_DIM3 =
  <<-JS
  JS

FINALIZE_SOU_DIM3 =
  <<-JS
  JS

MAP_SOU_DIM2 =
  <<-JS
  JS

REDUCE_SOU_DIM2 =
  <<-JS
  JS

FINALIZE_SOU_DIM2 =
  <<-JS
  JS

MAP_SOU_DIM1 =
  <<-JS
  JS

REDUCE_SOU_DIM1 =
  <<-JS
  JS

FINALIZE_SOU_DIM1 =
  <<-JS
  JS

MAP_SOU_DIM0 =
  <<-JS
  JS

REDUCE_SOU_DIM0 =
  <<-JS
  JS

FINALIZE_SOU_DIM0 =
  <<-JS
  JS