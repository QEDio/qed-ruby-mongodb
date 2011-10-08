# -*- encoding: utf-8 -*-
module Qaram
  module Test
    module Base
      # TODO: cleanup
      USER                                  = :test
      # TODO: end cleanup

      # Start: DateTIme-Plugin Params
      ### IDs
      FROM                                  = Qaram::Plugin::DateTime::FROM_ID.to_s
      TILL                                  = Qaram::Plugin::DateTime::TILL_ID.to_s
      STEP_SIZE                             = Qaram::Plugin::DateTime::STEP_SIZE_ID.to_s
      PREFIXED_FROM                         = Qaram::Plugin::DateTime.prefix+FROM
      PREFIXED_TILL                         = Qaram::Plugin::DateTime.prefix+TILL
      PREFIXED_STEP_SIZE                    = Qaram::Plugin::DateTime.prefix+STEP_SIZE

      ### VAlues
      FROM_VALUE                            = "2011-06-05 22:00:00 UTC"
      FROM_DATE_VALUE_TIME                  = Time.parse(FROM_VALUE)
      FROM_DATE_TRACKING_VALUE              = "2011-07-10 22:00:00 UTC"

      TILL_VALUE                            = "2011-12-09 22:00:00 UTC"
      TILL_DATE_VALUE_TIME                  = Time.parse(TILL_VALUE)
      TILL_DATE_TRACKING_VALUE              = "2011-07-20 22:00:00 UTC"

      STEP_SIZE_VALUE                       = 7
      # End: DateTIme-Plugin Params

      # Start: MapReduce-Plugin Params
      ### IDs
      PRODUCT_NAME                          = "product_name"
      PREFIXED_PRODUCT_NAME                 = Qaram::Plugin::MapReduce.prefix+PRODUCT_NAME

      ### Values
      PRODUCT_NAME_VALUE                    = "Elektromobil"
      PRODUCT_NAME_VALUE_GARAGE             = "Garage"
      PRODUCT_NAME_VALUE_SPECIAL_CHARS      = "Ää, Öö, Üü"
      # End: MapReduce-Plugin Params

      # Start: View-Plugin Params
      VIEW                                  = Qaram::Plugin::View::VIEW_ID.to_s
      ACTION                                = Qaram::Plugin::View::ACTION_ID.to_s
      CONTROLLER                            = Qaram::Plugin::View::CONTROLLER_ID.to_s
      PREFIXED_VIEW                         = Qaram::Plugin::View.prefix+VIEW
      PREFIXED_ACTION                       = Qaram::Plugin::View.prefix+ACTION
      PREFIXED_CONTROLLER                   = Qaram::Plugin::View.prefix+CONTROLLER

      VIEW_VALUE                            = "something else"
      ACTION_VALUE                          = "scale_of_universe"
      CONTROLLER_VALUE                      = "dashboard"
      # End: View-Plugin Params
    end
  end
end