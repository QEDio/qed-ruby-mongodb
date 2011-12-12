module Qed
  module Mongodb
    module MapReduce
      class Config
        KP_EW_1 = {
          :map => {
            :keys => [
              # TODO: if the function == "value."#{name} I don't want to write it down
              # if no keys provided use this key for initial mapreduce
              {:name => "campaign_product", :function => "value.campaign_product"}
            ],
            :values => [
              {:name => "campaign_holding",     :function => "value.campaign_holding"},
              {:name => "campaign_name",        :function => "value.campaign_name"},
              {:name => "conversions",          :function => "conversions"},
              {:name => "cost",                 :function => "cost"},
              {:name => "impressions",          :function => "impressions"},
              {:name => "clicks",               :function => "clicks"}
            ],
            :code => {
              :text =>  <<-JS
                          conversions   = value.ad_stat_conversions;
                          cost          = value.ad_cost_micro_amount / 1000000.0;
                          impressions   = value.ad_stat_impressions;
                          clicks        = value.ad_stat_clicks;
                        JS
            }
          },

          :reduce => {
            :values => [
              {:name => "campaign_holding",     :function => "value.campaign_holding"},
              {:name => "campaign_name",        :function => "value.campaign_name"},
              {:name => "conversions",          :function => "conversions"},
              {:name => "cost",                 :function => "cost"},
              {:name => "impressions",          :function => "impressions"},
              {:name => "clicks",               :function => "clicks"}
            ],
            :code => {
              :text =>  <<-JS
                  conversions   = 0;
                  cost          = 0;
                  impressions   = 0;
                  clicks        = 0;

                  values.forEach(function(v){
                    conversions           += v.conversions;
                    cost                  += v.cost;
                    impressions           += v.impressions;
                    clicks                += v.clicks;
                  });
              JS
            }
          },

          :finalize => {
            :values => [
                {:name => "conversions",          :function => "NumberLong(value.conversions)"},
                {:name => "cost",                 :function => "cost"},
                {:name => "impressions",          :function => "NumberLong(value.impressions)"},
                {:name => "cr"},
                {:name => "cpa"},
                {:name => "clicks",               :function => "NumberLong(value.clicks)"}

            ],
            :code => {
              :text =>  <<-JS
                          cpa = 0.0;
                          cr = 0.0;
                          cost = Math.round(value.cost * 100)/100;

                          if( value.clicks > 0 ){
                            cr = Math.round((value.conversions / value.clicks)*10000)/100;
                          }

                          if( value.conversions > 0 ){
                            cpa = Math.round((value.cost / value.conversions)*100)/100;
                          }
                        JS
            }
          },

          :misc => {
            :database               => "kp",
            :input_collection       => "adwords_early_warning_staging",
            :output_collection      => "mr_adwords_early_warning_staging",
          },

          :query => {
            :time_params            => ["ad_from", "ad_till"]
          }
        }

        KP_CBP_1 = {
          :map => {
            :keys => [
              {:name => "inquiry_id", :function => "NumberLong(value.inquiry_id)"}
            ],
            :values =>  [
              {:name => "inquiry_id",           :function => "NumberLong(value.inquiry_id)"},
              {:name => "status_id",            :function => "value.status_id"},
              {:name => "turnover"},
              {:name => "payed"},
              {:name => "product_name",         :function => "value.product_name"},
              {:name => "created_at",           :function => "value.created_at"},
              {:name => "product_uuid",         :function => "value.product_uuid"},
              {:name => "inquiry_id",           :function => "value.inquiry_id"},
              {:name => "tracking_ag",          :function => "value.tracking_ag"},
              {:name => "partner",              :function => "value.partner"},
              {:name => "level",                :function => "value.level"}
            ],
            :code => {
              :text =>    <<-JS
                            turnover = 0;
                            payed = 0;

                            if(value.lead_status_id == 1){turnover = value.leaddetails_price};
                            if(value.leaddetails_billing_status_id == 2){payed = value.leaddetails_price};
                          JS
            }
          },

          :reduce => {
            :values => [
              {:name => "inquiry_id",           :function => "NumberLong(value.inquiry_id)"},
              {:name => "status_id",            :function => "value.status_id"},
              {:name => "turnover"},
              {:name => "payed"},
              {:name => "product_name",         :function => "value.product_name"},
              {:name => "created_at",           :function => "value.created_at"},
              {:name => "product_uuid",         :function => "value.product_uuid"},
              {:name => "inquiry_id",           :function => "value.inquiry_id"},
              {:name => "tracking_ag",          :function => "value.tracking_ag"},
              {:name => "partner",              :function => "value.partner"},
              {:name => "level",                :function => "value.level"}
            ],
            :code => {
              :text => <<-JS
                        var turnover = 0;
                        var payed = 0;

                        values.forEach(function(v){
                          turnover += v.turnover;
                          payed += v.payed;
                        });
                      JS
            }
          },

          :finalize => {
            :values => [
              {:name => "inquiry_id",           :function => "NumberLong(value.inquiry_id)"},
              {:name => "status_id",            :function => "value.status_id"},
              {:name => "worked"},
              {:name => "test"},
              {:name => "qualified"},
              {:name => "turnover",             :function => "value.turnover"},
              {:name => "payed",                :function => "value.payed"},
              {:name => "product_name",         :function => "value.product_name"},
              {:name => "created_at",           :function => "value.created_at"},
              {:name => "product_uuid",         :function => "value.product_uuid"},
              {:name => "inquiry_id",           :function => "NumberLong(value.inquiry_id)"},
              {:name => "tracking_ag",          :function => "value.tracking_ag"},
              {:name => "partner",              :function => "value.partner"},
              {:name => "level",                :function => "value.level"}
            ],
            :code => {
              :text =>  <<-JS
                          worked = 1;
                          qualified = 1;
                          test = 0;

                          if(value.status_id == 0){worked=0};
                          if(value.status_id == 4){test=1};
                          if(value.status_id != 1){qualified=0};
                        JS
            },
          },

          :misc => {
            :database             => "qed_production",
            :input_collection     => "inquiries",
            :output_collection    => "mr_inquiries_jak4"
          },

          :query => {
            :time_params            => ["created_at"]
          }
        }

        KP_CBP_2 = {
          :map => {
            :keys => [
              {:name => "product_name",     :function => "value.product_name"}
            ],
            :values =>  [
              {:name => "product_name",         :function => "value.product_name"},
              {:name => "count"},
              {:name => "worked_on"},
              {:name => "qualified"},
              {:name => "test"},
              {:name => "turnover"},
              {:name => "payed"},
              {:name => "product_uuid",         :function => "value.product_uuid"},
              {:name => "inquiry_id",           :function => "value.inquiry_id"}
            ],
            :code => {
              :text =>   <<-JS
                          worked_on = 1;
                          qualified = 1;
                          test = 0;
                          count = 1;
                          turnover = value.turnover;
                          payed = value.payed;

                          if(value.status_id == 0){worked_on=0};
                          if(value.status_id == 4){test=1};
                          if(value.status_id != 1){qualified=0};
                        JS
            }
          },

          :reduce => {
            :values =>  [
              {:name => "product_name",         :function => "value.product_name"},
              {:name => "count"},
              {:name => "worked_on"},
              {:name => "qualified"},
              {:name => "test"},
              {:name => "turnover"},
              {:name => "payed"},
              {:name => "product_uuid",         :function => "value.product_uuid"},
              {:name => "inquiry_id",           :function => "value.inquiry_id"}
            ],
            :code => {
              :text =>  <<-JS
                          var count = 0;
                          var worked_on = 0;
                          var qualified = 0;
                          var test = 0;
                          var turnover = 0;
                          var payed = 0;

                          values.forEach(function(v){
                            count += v.count;
                            worked_on += v.worked_on;
                            qualified += v.qualified;
                            test += v.test;
                            turnover += v.turnover;
                            payed += v.payed
                          });
                        JS
            }
          },

          :finalize => {
            :values => [
              {:name => "product_name",         :function => "value.product_name"},
              {:name => "count",                :function => "value.count"},
              {:name => "worked_on",            :function => "value.worked_on"},
              {:name => "qualified",            :function => "value.qualified"},
              {:name => "test",                 :function => "value.test"},
              {:name => "turnover",             :function => "value.turnover"},
              {:name => "payed",                :function => "value.payed"},
              {:name => "product_uuid",         :function => "value.product_uuid"},
              {:name => "inquiry_id",           :function => "value.inquiry_id"}
            ]
          },

          :misc => {
            :database             => "qed_production",
            :input_collection     => "mr_inquiries_jak4",
            :output_collection    => "mr_suppa_jak4",
          },

          :query => {
            :time_params          => ["created_at"]
          }
        }

        KP_CBC_2 = {
          :map => {
            :keys => [
              {:name => "ag",               :function => "value.tracking_ag"}
            ],
            :values =>  [
              {:name => "tracking_ag",          :function => "value.tracking_ag"},
              {:name => "count"},
              {:name => "worked_on"},
              {:name => "qualified"},
              {:name => "test"},
              {:name => "turnover"},
              {:name => "payed"},
              {:name => "product_uuid",         :function => "value.product_uuid"},
              {:name => "inquiry_id",           :function => "value.inquiry_id"}
            ],
            :code => {
              :text =>  <<-JS
                          worked = 1;
                          qualified = 1;
                          test = 0;

                          if(value.status_id == 0){worked=0};
                          if(value.status_id == 4){test=1};
                          if(value.status_id != 1){qualified=0};
                        JS
            }
          },

          :reduce => {
            :values =>  [
              {:name => "tracking_ag",          :function => "value.tracking_ag"},
              {:name => "count"},
              {:name => "worked_on"},
              {:name => "qualified"},
              {:name => "test"},
              {:name => "turnover"},
              {:name => "payed"},
              {:name => "product_uuid",         :function => "value.product_uuid"},
              {:name => "inquiry_id",           :function => "value.inquiry_id"}
            ],
            :code => {
              :text =>  <<-JS
                          var count = 0;
                          var worked_on = 0;
                          var qualified = 0;
                          var test = 0;
                          var turnover = 0;
                          var payed = 0;

                          values.forEach(function(v){
                            count += v.count;
                            worked_on += v.worked_on;
                            qualified += v.qualified;
                            test += v.test;
                            turnover += v.turnover;
                            payed += v.payed
                          });
                        JS
            }
          },

          :finalize => {
            :values => [
              {:name => "tracking_ag",          :function => "value.tracking_ag"},
              {:name => "count",                :function => "value.count"},
              {:name => "worked_on",            :function => "value.worked_on"},
              {:name => "qualified",            :function => "value.qualified"},
              {:name => "test",                 :function => "value.test"},
              {:name => "turnover",             :function => "value.turnover"},
              {:name => "payed",                :function => "value.payed"},
              {:name => "product_uuid",         :function => "value.product_uuid"},
              {:name => "inquiry_id",           :function => "value.inquiry_id"}
            ]
          },

          :misc => {
            :database             => "qed_production",
            :input_collection     => "mr_inquiries_jak4",
            :output_collection    => "mr_suppa_jak4"
          },

          :query => {
            :time_params          => ["created_at"]
          }
        }

        KP_TRA_2 = {
          :map => {
            :mapreduce_keys => [
              {:name => nil,                    :function => "(value.product_name+domain+value.level)"}
            ],
            :values =>  [
              {:name => "tracking_ag",          :function => "value.tracking_ag"},
              {:name => "count"},
              {:name => "worked_on"},
              {:name => "qualified"},
              {:name => "test"},
              {:name => "turnover"},
              {:name => "payed"},
              {:name => "product_uuid",         :function => "value.product_uuid"},
              {:name => "inquiry_id",           :function => "value.inquiry_id"},
              {:name => "domain"},
              {:name => "level",                :function => "value.level"}
            ],
            :code => {
              :text =>  <<-JS
                          worked_on = value.worked_on;
                          qualified = value.qualified;
                          test = value.test;
                          count = 1;
                          turnover = value.turnover;
                          payed = value.payed;
                          domain = value.partner;
                          verticals = [
                            'DKB', 'GARACAR', 'GASTADE', 'SOLARDE', 'TLF', 'TREPEXDE',
                            'TREPFADE', 'DTB', 'GABEDE', 'GARACOM', 'GARANET', 'GAVEDE',
                            'SOPHONET', 'TORG', 'WAFA', 'WEBANCOM'
                          ]
                          if(verticals.indexOf(domain) == -1){
                            domain = 'KP'
                          }
                        JS
            }
          },

          :reduce => {
            :values =>  [
              {:name => "tracking_ag",          :function => "value.tracking_ag"},
              {:name => "count"},
              {:name => "worked_on"},
              {:name => "qualified"},
              {:name => "test"},
              {:name => "turnover"},
              {:name => "payed"},
              {:name => "product_uuid",         :function => "value.product_uuid"},
              {:name => "inquiry_id",           :function => "value.inquiry_id"},
              {:name => "domain"},
              {:name => "level",                :function => "value.level"}
            ],
            :code => {
              :text =>  <<-JS
                          var count = 0;
                          var worked_on = 0;
                          var qualified = 0;
                          var test = 0;
                          var turnover = 0;
                          var payed = 0;
                          var domain = value.domain;

                          values.forEach(function(v){
                            count += v.count;
                            worked_on += v.worked_on;
                            qualified += v.qualified;
                            test += v.test;
                            turnover += v.turnover;
                            payed += v.payed
                          });
                        JS
            }
          },

          :finalize => {
            :values => [
              {:name => "tracking_ag",          :function => "value.tracking_ag"},
              {:name => "count",                :function => "value.count"},
              {:name => "worked_on",            :function => "value.worked_on"},
              {:name => "qualified",            :function => "value.qualified"},
              {:name => "test",                 :function => "value.test"},
              {:name => "turnover",             :function => "value.turnover"},
              {:name => "payed",                :function => "value.payed"},
              {:name => "product_uuid",         :function => "value.product_uuid"},
              {:name => "inquiry_id",           :function => "value.inquiry_id"},
              {:name => "domain",               :function => "value.domain"},
              {:name => "level",                :function => "value.level"}
            ]
          },

          :misc => {
            :database             => "qed_production",
            :input_collection     => "mr_inquiries_jak4",
            :output_collection    => "mr_suppa_jak4",
          },

          :query => {
            :time_params          => ["created_at"]
          }
        }
      end
    end
  end
end

