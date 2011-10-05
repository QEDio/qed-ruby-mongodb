unless Kernel.const_defined?("QB_FM1")
  QB_FM1 =
    {
      DRILLDOWN_LEVEL_CURRENT           =>  DRILLDOWN_LEVEL_CURRENT_VALUE,
      FROM_DATE                         =>  FROM_DATE_VALUE,
      TILL_DATE                         =>  TILL_DATE_VALUE,
      M_S_PRODUCT_NAME                  =>  M_S_PRODUCT_NAME_VALUE,
      ACTION                            =>  ACTION_NAME_MR2_VALUE,
      ACTION_NAME                       =>  ACTION_NAME_MR2_VALUE,
      CONTROLLER                        =>  CONTROLLER_VALUE
    }

  # a little bit more dynamic would be nice
  QB_QUERY1 = '{:"value.date_field1"=>{"$gte"=>2011-06-05 22:00:00 UTC, "$lt"=>2011-12-09 22:00:00 UTC}, :"value.date_field2"=>{"$gte"=>2011-06-05 22:00:00 UTC, "$lt"=>2011-12-09 22:00:00 UTC}, "value.product_name"=>"Elektromobil"}'
end