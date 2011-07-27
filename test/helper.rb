$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'test/unit'
require 'shoulda'

require 'qed-mongodb'

FROM_DATE                             = "from_date"
FROM_DATE_VALUE                       = "2011-06-05 22:00:00 UTC"
FROM_DATE_TRACKING_VALUE              = "2011-06-05 22:00:00 UTC"
TILL_DATE                             = "till_date"
TILL_DATE_VALUE                       = "2011-12-09 22:00:00 UTC"
TILL_DATE_TRACKING_VALUE              = "2011-06-06 22:00:00 UTC"
USER                                  = :kp

PRODUCT_NAME                          = "product_name"
M_S_PRODUCT_NAME                      = "m_s_#{PRODUCT_NAME}"
M_S_PRODUCT_NAME_VALUE                = "Elektromobil"
M_S_PRODUCT_NAME_VALUE_GARAGE         = "Garage"

DRILLDOWN_LEVEL_CURRENT               = "i_drilldown_level_current"
DRILLDOWN_LEVEL_CURRENT_VALUE         = "0"
DRILLDOWN_LEVEL_NEXT_VALUE            = "1"
VIEW                                  = "view"
ACTION                                = "action"
ACTION_NAME                           = "action_name"
ACTION_NAME_VALUE                     = "conversion_by_product"
ACTION_NAME_TRACKING_VALUE            = "tracking"
CONTROLLER                            = "controller"
CONTROLLER_VALUE                      = "dashboard"

PARAMS =
  {
    DRILLDOWN_LEVEL_CURRENT           =>  DRILLDOWN_LEVEL_CURRENT_VALUE,
    FROM_DATE                         =>  FROM_DATE_VALUE,
    TILL_DATE                         =>  TILL_DATE_VALUE,
    M_S_PRODUCT_NAME                  =>  M_S_PRODUCT_NAME_VALUE,
    ACTION                            =>  ACTION_NAME_VALUE,
    ACTION_NAME                       =>  ACTION_NAME_VALUE,
    CONTROLLER                        =>  CONTROLLER_VALUE
  }

PARAMS_TRACKING =
  {
    DRILLDOWN_LEVEL_CURRENT           =>  DRILLDOWN_LEVEL_CURRENT_VALUE,
    FROM_DATE                         =>  FROM_DATE_TRACKING_VALUE,
    TILL_DATE                         =>  TILL_DATE_TRACKING_VALUE,
    ACTION                            =>  ACTION_NAME_TRACKING_VALUE,
    ACTION_NAME                       =>  ACTION_NAME_TRACKING_VALUE,
    CONTROLLER                        =>  CONTROLLER_VALUE
  }

FM_GENERATED_PARAMS_URL_WITH_ADDITIONAL_PARAMETERS =
    "?#{VIEW}=#{ACTION_NAME_VALUE}&#{DRILLDOWN_LEVEL_CURRENT}=#{DRILLDOWN_LEVEL_NEXT_VALUE}&#{FROM_DATE}=#{FROM_DATE_VALUE}&#{TILL_DATE}=#{TILL_DATE_VALUE}&#{M_S_PRODUCT_NAME}=#{M_S_PRODUCT_NAME_VALUE_GARAGE}".gsub(/ /,"%20")
FM_GENERATED_PARAMS_URL =
    "?#{VIEW}=#{ACTION_NAME_VALUE}&#{DRILLDOWN_LEVEL_CURRENT}=#{DRILLDOWN_LEVEL_CURRENT_VALUE}&#{FROM_DATE}=#{FROM_DATE_VALUE}&#{TILL_DATE}=#{TILL_DATE_VALUE}&#{M_S_PRODUCT_NAME}=#{M_S_PRODUCT_NAME_VALUE}".gsub(/ /,"%20")

URL_ROW                               = {"_id"=>"#{M_S_PRODUCT_NAME_VALUE_GARAGE}", "value"=>{"product_name"=>"#{M_S_PRODUCT_NAME_VALUE_GARAGE}", "count"=>984.0, "worked_on"=>951.0, "qualified"=>497.0, "test"=>37.0, "turnover"=>19560.0, "payed"=>0.0, "product_uuid"=>"0892afe0b494012d895138ac6f7d89ab", "inquiry_id"=>185968}}
URL_KEY                               = "product_name"
URL_FIELD                             = M_S_PRODUCT_NAME_VALUE_GARAGE
PARAMS_RESULTING_MONGODB_QUERY = '{:"value.created_at"=>{"$gte"=>2011-06-05 22:00:00 UTC, "$lt"=>2011-12-09 22:00:00 UTC}, "value.product_name"=>"Elektromobil"}'

class Test::Unit::TestCase
  include Qed::Mongodb
end
