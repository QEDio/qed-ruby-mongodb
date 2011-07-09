$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'test/unit'
require 'shoulda'

require 'qed-mongodb'


USER                                  = :kp
M_S_PRODUCT_NAME                      = "Elektromobil"
PARAMS =
  {
    "i_drilldown_level_current"       =>  "1",
    "from_date"                       =>  "2011-06-05 22:00:00 UTC",
    "till_date"                       =>  "2011-07-08 22:00:00 UTC",
    "m_s_product_name"                =>  M_S_PRODUCT_NAME,
    "action"                          =>  "conversion_by_product",
    "controller"                      =>  "dashboard"
  }

PARAMS_RESULTING_MONGODB_QUERY = '{:"value.created_at"=>{"$gte"=>2011-07-07 22:00:00 UTC, "$lt"=>2011-07-08 22:00:00 UTC}}'

class Test::Unit::TestCase
  include Qed::Mongodb
end
