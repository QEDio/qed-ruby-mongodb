$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'test/unit'
require 'shoulda'

require 'qed-mongodb'

FROM_DATE                             = "2011-06-05 22:00:00 UTC"
TILL_DATE                             = "2011-12-09 22:00:00 UTC"
USER                                  = :kp


M_S_PRODUCT_NAME                      = "Elektromobil"
ACTION_NAME                           = "conversion_by_product"

PARAMS =
  {
    "i_drilldown_level_current"       =>  "1",
    "from_date"                       =>  FROM_DATE,
    "till_date"                       =>  TILL_DATE,
    "m_s_product_name"                =>  M_S_PRODUCT_NAME,
    "action"                          =>  ACTION_NAME,
    "action_name"                     =>  ACTION_NAME,
    "controller"                      =>  "dashboard"
  }

URL_ROW                               = {"_id"=>"Garage", "value"=>{"product_name"=>"Garage", "count"=>984.0, "worked_on"=>951.0, "qualified"=>497.0, "test"=>37.0, "turnover"=>19560.0, "payed"=>0.0, "product_uuid"=>"0892afe0b494012d895138ac6f7d89ab", "inquiry_id"=>185968}}
URL_KEY                               = "product_name"
URL_FIELD                             = "Garage"
PARAMS_RESULTING_MONGODB_QUERY = '{:"value.created_at"=>{"$gte"=>2011-06-05 22:00:00 UTC, "$lt"=>2011-12-09 22:00:00 UTC}, "value.product_name"=>"Elektromobil"}'

class Test::Unit::TestCase
  include Qed::Mongodb
end
