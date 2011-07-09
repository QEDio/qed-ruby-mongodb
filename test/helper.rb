$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'test/unit'
require 'shoulda'

require 'qed-mongodb'

FROM_DATE                             = "2011-06-05 22:00:00 UTC"
TILL_DATE                             = "2011-07-08 22:00:00 UTC"
USER                                  = :kp
M_S_PRODUCT_NAME                      = "Elektromobil"
PARAMS =
  {
    "i_drilldown_level_current"       =>  "1",
    "from_date"                       =>  FROM_DATE,
    "till_date"                       =>  TILL_DATE,
    "m_s_product_name"                =>  M_S_PRODUCT_NAME,
    "action"                          =>  "conversion_by_product",
    "controller"                      =>  "dashboard"
  }

PARAMS_RESULTING_MONGODB_QUERY = '{:"value.created_at"=>{"$gte"=>Fri, 08 Jul 2011 00:00:00 +0000, "$lt"=>Sat, 09 Jul 2011 00:00:00 +0000}, "value.product_name"=>"Elektromobil"}'

class Test::Unit::TestCase
  include Qed::Mongodb
end
