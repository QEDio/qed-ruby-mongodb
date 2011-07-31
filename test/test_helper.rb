require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

end

Spork.each_run do
  # This code will be run each time you run your specs.

end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.




$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'test/unit'
require 'shoulda'

require 'qed-mongodb'


unless Kernel.const_defined?("FROM_DATE")
  require 'test_helper_mapreduce_config'
  require 'test_mongodb_factory'

  FROM_DATE                             = "from_date"
  FROM_DATE_VALUE                       = "2011-06-05 22:00:00 UTC"
  FROM_DATE_TRACKING_VALUE              = "2011-07-10 22:00:00 UTC"
  TILL_DATE                             = "till_date"
  TILL_DATE_VALUE                       = "2011-12-09 22:00:00 UTC"
  TILL_DATE_TRACKING_VALUE              = "2011-07-20 22:00:00 UTC"
  USER                                  = :test

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
  ACTION_NAME_MR2_VALUE                 = "mapreduce_2"
  ACTION_NAME_MR3_VALUE                 = "mapreduce_3"
  ACTION_NAME_SCALE_OF_UNIVERSE         = "scale_of_universe"
  CONTROLLER                            = "controller"
  CONTROLLER_VALUE                      = "dashboard"

  PARAMS_SCALE_OF_UNIVERSE =
    {
      DRILLDOWN_LEVEL_CURRENT           =>  9999999,
      ACTION                            =>  ACTION_NAME_SCALE_OF_UNIVERSE,
      ACTION_NAME                       =>  ACTION_NAME_SCALE_OF_UNIVERSE,
      CONTROLLER                        =>  CONTROLLER_VALUE
    }

  PARAMS_MR2 =
    {
      DRILLDOWN_LEVEL_CURRENT           =>  DRILLDOWN_LEVEL_CURRENT_VALUE,
      FROM_DATE                         =>  FROM_DATE_VALUE,
      TILL_DATE                         =>  TILL_DATE_VALUE,
      M_S_PRODUCT_NAME                  =>  M_S_PRODUCT_NAME_VALUE,
      ACTION                            =>  ACTION_NAME_MR2_VALUE,
      ACTION_NAME                       =>  ACTION_NAME_MR2_VALUE,
      CONTROLLER                        =>  CONTROLLER_VALUE
    }

  PARAMS_MR3 =
    {
      DRILLDOWN_LEVEL_CURRENT           =>  DRILLDOWN_LEVEL_CURRENT_VALUE,
      FROM_DATE                         =>  FROM_DATE_TRACKING_VALUE,
      TILL_DATE                         =>  TILL_DATE_TRACKING_VALUE,
      ACTION                            =>  ACTION_NAME_MR3_VALUE,
      ACTION_NAME                       =>  ACTION_NAME_MR3_VALUE,
      CONTROLLER                        =>  CONTROLLER_VALUE
    }

  FM_GENERATED_PARAMS_URL_WITH_ADDITIONAL_PARAMETERS =
      "?#{VIEW}=#{ACTION_NAME_MR2_VALUE}&#{DRILLDOWN_LEVEL_CURRENT}=#{DRILLDOWN_LEVEL_NEXT_VALUE}&#{FROM_DATE}=#{FROM_DATE_VALUE}&#{TILL_DATE}=#{TILL_DATE_VALUE}&#{M_S_PRODUCT_NAME}=#{M_S_PRODUCT_NAME_VALUE_GARAGE}".gsub(/ /,"%20")
  FM_GENERATED_PARAMS_URL =
      "?#{VIEW}=#{ACTION_NAME_MR2_VALUE}&#{DRILLDOWN_LEVEL_CURRENT}=#{DRILLDOWN_LEVEL_CURRENT_VALUE}&#{FROM_DATE}=#{FROM_DATE_VALUE}&#{TILL_DATE}=#{TILL_DATE_VALUE}&#{M_S_PRODUCT_NAME}=#{M_S_PRODUCT_NAME_VALUE}".gsub(/ /,"%20")

  URL_ROW                               = {"_id"=>"#{M_S_PRODUCT_NAME_VALUE_GARAGE}", "value"=>{"product_name"=>"#{M_S_PRODUCT_NAME_VALUE_GARAGE}", "count"=>984.0, "worked_on"=>951.0, "qualified"=>497.0, "test"=>37.0, "turnover"=>19560.0, "payed"=>0.0, "product_uuid"=>"0892afe0b494012d895138ac6f7d89ab", "inquiry_id"=>185968}}
  URL_KEY                               = "product_name"
  URL_FIELD                             = M_S_PRODUCT_NAME_VALUE_GARAGE
  PARAMS_RESULTING_MONGODB_QUERY = '{:"value.created_at"=>{"$gte"=>2011-06-05 22:00:00 UTC, "$lt"=>2011-12-09 22:00:00 UTC}, "value.product_name"=>"Elektromobil"}'
end

class Test::Unit::TestCase
  include Qed::Mongodb
end
