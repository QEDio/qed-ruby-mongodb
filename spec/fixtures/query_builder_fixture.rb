module Qed
  module Mongodb
    module Test
      module Fixtures
        module QueryBuilder
          include Qstate::Test::Fixtures::Base

          QB_PARAMS_1 =
            {
              PREFIXED_FROM                     => FROM_VALUE,
              PREFIXED_TILL                     => TILL_VALUE,
              PREFIXED_PRODUCT_NAME             => PRODUCT_NAME_VALUE,
              PREFIXED_ACTION                   => ACTION_VALUE,
              PREFIXED_CONTROLLER               => CONTROLLER_VALUE,
              PREFIXED_VIEW                     => VIEW_VALUE,
              PREFIXED_PRODUCT_NAME             => PRODUCT_NAME_VALUE
            }

          # a little bit more dynamic would be nice
          QB_QUERY1 = '{:"value.date_field1"=>{"$gte"=>2011-06-05 22:00:00 UTC, "$lt"=>2011-12-09 22:00:00 UTC}, :"value.date_field2"=>{"$gte"=>2011-06-05 22:00:00 UTC, "$lt"=>2011-12-09 22:00:00 UTC}, "value.product_name"=>"Elektromobil"}'
        end
      end
    end
  end
end