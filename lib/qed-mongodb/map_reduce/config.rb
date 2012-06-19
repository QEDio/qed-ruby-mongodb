module Qed
  module Mongodb
    module MapReduce
      class Config
        KP_EW_1 = {
          :map => {
            :keys => [
              # TODO: if the function == "value."#{name} I don't want to write it down
              # if no keys provided use this key for initial mapreduce
              {:name => 'campaign_product', :function => 'value.campaign_product'}
            ],
            :values => [
              {:name => 'campaign_holding',     :function => 'value.campaign_holding'},
              {:name => 'campaign_name',        :function => 'value.campaign_name'},
              {:name => 'conversions',          :function => 'conversions'},
              {:name => 'cost',                 :function => 'cost'},
              {:name => 'impressions',          :function => 'impressions'},
              {:name => 'clicks',               :function => 'clicks'}
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
              {:name => 'campaign_holding',     :function => 'value.campaign_holding'},
              {:name => 'campaign_name',        :function => 'value.campaign_name'},
              {:name => 'conversions',          :function => 'conversions'},
              {:name => 'cost',                 :function => 'cost'},
              {:name => 'impressions',          :function => 'impressions'},
              {:name => 'clicks',               :function => 'clicks'}
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
                {:name => 'conversions',          :function => 'NumberLong(value.conversions)'},
                {:name => 'cost',                 :function => 'cost'},
                {:name => 'impressions',          :function => 'NumberLong(value.impressions)'},
                {:name => 'cr'},
                {:name => 'cpa'},
                {:name => 'clicks',               :function => 'NumberLong(value.clicks)'}

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
            :database               => 'kp',
            :input_collection       => 'adwords_early_warning_staging',
            :output_collection      => 'mr_adwords_early_warning_staging',
          },

          :query => {
            :datetime_fields            => ['ad_from', 'ad_till']
          }
        }

        KP_CBP_1 = {
          :map => {
            :keys => [
              {:name => 'inquiry_id', :function => 'NumberLong(value.inquiry_id)'}
            ],
            :values =>  [
              {:name => 'inquiry_id',           :function => 'NumberLong(value.inquiry_id)'},
              {:name => 'status_id',            :function => 'value.status_id'},
              {:name => 'turnover'},
              {:name => 'payed'},
              {:name => 'product_name',         :function => 'value.product_name'},
              {:name => 'created_at',           :function => 'value.created_at'},
              {:name => 'product_uuid',         :function => 'value.product_uuid'},
              {:name => 'inquiry_id',           :function => 'value.inquiry_id'},
              {:name => 'tracking_ag',          :function => 'value.tracking_ag'},
              {:name => 'partner',              :function => 'value.partner'},
              {:name => 'level',                :function => 'value.level'}
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
              {:name => 'inquiry_id',           :function => 'NumberLong(value.inquiry_id)'},
              {:name => 'status_id',            :function => 'value.status_id'},
              {:name => 'turnover'},
              {:name => 'payed'},
              {:name => 'product_name',         :function => 'value.product_name'},
              {:name => 'created_at',           :function => 'value.created_at'},
              {:name => 'product_uuid',         :function => 'value.product_uuid'},
              {:name => 'inquiry_id',           :function => 'value.inquiry_id'},
              {:name => 'tracking_ag',          :function => 'value.tracking_ag'},
              {:name => 'partner',              :function => 'value.partner'},
              {:name => 'level',                :function => 'value.level'}
            ],
            :code => {
              :text => <<-JS
                        var turnover  = 0;
                        var payed     = 0;

                        values.forEach(function(v){
                          turnover  += v.turnover;
                          payed     += v.payed;
                        });
                      JS
            }
          },

          :finalize => {
            :values => [
              {:name => 'inquiry_id',           :function => 'NumberLong(value.inquiry_id)'},
              {:name => 'status_id',            :function => 'value.status_id'},
              {:name => 'worked'},
              {:name => 'test'},
              {:name => 'qualified'},
              {:name => 'turnover',             :function => 'value.turnover'},
              {:name => 'payed',                :function => 'value.payed'},
              {:name => 'product_name',         :function => 'value.product_name'},
              {:name => 'created_at',           :function => 'value.created_at'},
              {:name => 'product_uuid',         :function => 'value.product_uuid'},
              {:name => 'inquiry_id',           :function => 'NumberLong(value.inquiry_id)'},
              {:name => 'tracking_ag',          :function => 'value.tracking_ag'},
              {:name => 'partner',              :function => 'value.partner'},
              {:name => 'level',                :function => 'value.level'}
            ],
            :code => {
              :text =>  <<-JS
                          worked    = 1;
                          qualified = 1;
                          test      = 0;

                          if(value.status_id == 0){worked=0};
                          if(value.status_id == 4){test=1};
                          if(value.status_id != 1){qualified=0};
                        JS
            },
          },

          :misc => {
            :database             => 'qed_production',
            :input_collection     => 'inquiries',
            :output_collection    => 'mr_inquiries_jak4'
          },

          :query => {
            :datetime_fields            => ['created_at']
          }
        }

        KP_CBP_2 = {
          :map => {
            :keys => [
              {:name => 'product_name',     :function => 'value.product_name'}
            ],
            :values =>  [
              {:name => 'product_name',         :function => 'value.product_name'},
              {:name => 'count'},
              {:name => 'worked_on'},
              {:name => 'qualified'},
              {:name => 'test'},
              {:name => 'turnover'},
              {:name => 'payed'},
              {:name => 'product_uuid',         :function => 'value.product_uuid'},
              {:name => 'inquiry_id',           :function => 'value.inquiry_id'}
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
              {:name => 'product_name',         :function => 'value.product_name'},
              {:name => 'count'},
              {:name => 'worked_on'},
              {:name => 'qualified'},
              {:name => 'test'},
              {:name => 'turnover'},
              {:name => 'payed'},
              {:name => 'product_uuid',         :function => 'value.product_uuid'},
              {:name => 'inquiry_id',           :function => 'value.inquiry_id'}
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
              {:name => 'product_name',         :function => 'value.product_name'},
              {:name => 'count',                :function => 'value.count'},
              {:name => 'worked_on',            :function => 'value.worked_on'},
              {:name => 'qualified',            :function => 'value.qualified'},
              {:name => 'test',                 :function => 'value.test'},
              {:name => 'turnover',             :function => 'value.turnover'},
              {:name => 'payed',                :function => 'value.payed'},
              {:name => 'product_uuid',         :function => 'value.product_uuid'},
              {:name => 'inquiry_id',           :function => 'value.inquiry_id'}
            ]
          },

          :misc => {
            :database             => 'qed_production',
            :input_collection     => 'mr_inquiries_jak4',
            :output_collection    => 'mr_suppa_jak4',
          },

          :query => {
            :datetime_fields          => ['created_at']
          }
        }

        KP_CBC_2 = {
          :map => {
            :keys => [
              {:name => 'ag',               :function => 'value.tracking_ag'}
            ],
            :values =>  [
              {:name => 'tracking_ag',          :function => 'value.tracking_ag'},
              {:name => 'count'},
              {:name => 'worked_on'},
              {:name => 'qualified'},
              {:name => 'test'},
              {:name => 'turnover'},
              {:name => 'payed'},
              {:name => 'product_uuid',         :function => 'value.product_uuid'},
              {:name => 'inquiry_id',           :function => 'value.inquiry_id'}
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
              {:name => 'tracking_ag',          :function => 'value.tracking_ag'},
              {:name => 'count'},
              {:name => 'worked_on'},
              {:name => 'qualified'},
              {:name => 'test'},
              {:name => 'turnover'},
              {:name => 'payed'},
              {:name => 'product_uuid',         :function => 'value.product_uuid'},
              {:name => 'inquiry_id',           :function => 'value.inquiry_id'}
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
              {:name => 'tracking_ag',          :function => 'value.tracking_ag'},
              {:name => 'count',                :function => 'value.count'},
              {:name => 'worked_on',            :function => 'value.worked_on'},
              {:name => 'qualified',            :function => 'value.qualified'},
              {:name => 'test',                 :function => 'value.test'},
              {:name => 'turnover',             :function => 'value.turnover'},
              {:name => 'payed',                :function => 'value.payed'},
              {:name => 'product_uuid',         :function => 'value.product_uuid'},
              {:name => 'inquiry_id',           :function => 'value.inquiry_id'}
            ]
          },

          :misc => {
            :database             => 'qed_production',
            :input_collection     => 'mr_inquiries_jak4',
            :output_collection    => 'mr_suppa_jak4'
          },

          :query => {
            :datetime_fields          => ['created_at']
          }
        }

        KP_TRA_2 = {
          :map => {
            :mapreduce_keys => [
              {:name => nil,                    :function => '(value.product_name+domain+value.level)'}
            ],
            :values =>  [
              {:name => 'tracking_ag',          :function => 'value.tracking_ag'},
              {:name => 'count'},
              {:name => 'worked_on'},
              {:name => 'qualified'},
              {:name => 'test'},
              {:name => 'turnover'},
              {:name => 'payed'},
              {:name => 'product_uuid',         :function => 'value.product_uuid'},
              {:name => 'inquiry_id',           :function => 'value.inquiry_id'},
              {:name => 'domain'},
              {:name => 'level',                :function => 'value.level'}
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
              {:name => 'tracking_ag',          :function => 'value.tracking_ag'},
              {:name => 'count'},
              {:name => 'worked_on'},
              {:name => 'qualified'},
              {:name => 'test'},
              {:name => 'turnover'},
              {:name => 'payed'},
              {:name => 'product_uuid',         :function => 'value.product_uuid'},
              {:name => 'inquiry_id',           :function => 'value.inquiry_id'},
              {:name => 'domain'},
              {:name => 'level',                :function => 'value.level'}
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
              {:name => 'tracking_ag',          :function => 'value.tracking_ag'},
              {:name => 'count',                :function => 'value.count'},
              {:name => 'worked_on',            :function => 'value.worked_on'},
              {:name => 'qualified',            :function => 'value.qualified'},
              {:name => 'test',                 :function => 'value.test'},
              {:name => 'turnover',             :function => 'value.turnover'},
              {:name => 'payed',                :function => 'value.payed'},
              {:name => 'product_uuid',         :function => 'value.product_uuid'},
              {:name => 'inquiry_id',           :function => 'value.inquiry_id'},
              {:name => 'domain',               :function => 'value.domain'},
              {:name => 'level',                :function => 'value.level'}
            ]
          },

          :misc => {
            :database             => 'qed_production',
            :input_collection     => 'mr_inquiries_jak4',
            :output_collection    => 'mr_suppa_jak4',
          },

          :query => {
            :datetime_fields          => ['created_at']
          }
        }

        KP_ADWORDS_DB_1 = {
          map: {
            keys: [
              {name: 'inquiry_id',           function: 'value.inquiry_id', exchangeable: false}
            ],
            values: [
              {name: 'inquiry_id',           function: 'value.inquiry_id'},
              {name: 'turnover'},
              {name: 'payed'},
              {name: 'created_at',           function: 'value.created_at'},
              {name: 'ad_group_ad_id',       function: 'value.ad_group_ad_id'},
              {name: 'status_id',            function: 'value.status_id'},
              {name: 'partner',              function: 'value.partner'},
            ],
            code: {
              text:  <<-JS
                          var turnover 		= 0;
                          var payed 		  = 0;

                          if(value.lead_status_id == 1){turnover = value.leaddetails_price};
                          if(value.leaddetails_billing_status_id == 2){payed = value.leaddetails_price};
                        JS
            }
          },

          reduce: {
            values: [
              {name: 'inquiry_id',           function: 'value.inquiry_id'},
              {name: 'turnover'},
              {name: 'payed'},
              {name: 'created_at',           function: 'value.created_at'},
              {name: 'ad_group_ad_id',       function: 'value.ad_group_ad_id'},
              {name: 'status_id',            function: 'value.status_id'},
              {name: 'partner',              function: 'value.partner'}
            ],
            code: {
              text:  <<-JS
                          var turnover  = 0;
                          var payed     = 0;

                          values.forEach(function(v){
                            turnover 	+= v.turnover;
                            payed 	  += v.payed;
                          });
                        JS
            }
          },

          finalize: {
            values: [
              {name: 'inquiry_id',           function: 'value.inquiry_id'},
              {name: 'turnover',             function: 'value.turnover'},
              {name: 'payed',                function: 'value.payed'},
              {name: 'created_at',           function: 'value.created_at'},
              {name: 'ad_group_ad_id',       function: 'value.ad_group_ad_id'},
              {name: 'status_id',            function: 'value.status_id'},
              {name: 'worked'},
              {name: 'qualified'},
              {name: 'partner',              function: 'value.partner'}
            ],
            code: {
              text:  <<-JS
                          worked    = 1;
                          qualified = 1;

                          if(value.status_id == 0){worked=0};
                          if(value.status_id != 1){qualified=0};
                        JS
            },
          },

          misc: {
            database:           'kp',
            input_collection:   'kp_backend_staging',
            output_collection:  'tmp.adwords_db_1'
          },

          query: {
            datetime_fields: ['created_at'],
            condition: [{field: 'value.adlink', value: [false]}]
          }
        }

        KP_ADWORDS_DB_2 = {
          map: {
            keys: [
              {name: 'ad_group_ad_id',         function: 'value.ad_group_ad_id'}
            ],
            values: [
              {name: 'turnover',               function: 'value.turnover'},
              {name: 'payed',                  function: 'value.payed'},
              {name: 'cost',                   function: '0'},
              {name: 'product_name',           function: '""'},
              {name: 'holding_name',           function: '""'},
              {name: 'campaign_name',          function: '""'},
              {name: 'campaign_id',            function: '""'},
              {name: 'ad_group_name',          function: '""'},
              {name: 'ad_group_id',            function: '""'},
              {name: 'conversions_adwords',    function: '0'},
              {name: 'conversions_backend',    function: '1'},
              {name: 'worked',                 function: 'value.worked'},
              {name: 'qualified',              function: 'value.qualified'},
              {name: 'partner',                function: 'value.partner'},
              {name: 'ad_group_status',        function: '""'}
            ]
          },

          reduce: {
            values: [
              {name: 'turnover'},
              {name: 'cost'},
              {name: 'product_name',           function: 'value.product_name'},
              {name: 'holding_name',           function: 'value.holding_name'},
              {name: 'campaign_name',          function: 'value.campaign_name'},
              {name: 'campaign_id',            function: 'value.campaign_id'},
              {name: 'ad_group_name',          function: 'value.ad_group_name'},
              {name: 'ad_group_id',            function: 'value.ad_group_id'},
              {name: 'conversions_backend'},
              {name: 'conversions_adwords',    function: '0'},
              {name: 'worked'},
              {name: 'qualified'},
              {name: 'partner',                function: 'value.partner'},
              {name: 'ad_group_status',        function: 'value.ad_group_status'}
            ],

            code: {
              text:  <<-JS
                          var turnover			      = 0;
                          var payed               = 0;
                          var cost			          = 0;
                          var conversions_backend	= 0;
                          var worked              = 0;
                          var qualified           = 0;

                          values.forEach(function(v){
                            cost     		        += v.cost;
                            payed               += v.payed;
                            turnover 		        += v.turnover;
                            conversions_backend	+= v.conversions_backend;
                            worked              += v.worked;
                            qualified           += v.qualified;
                          });
                        JS
            }
          },

          finalize: {
            values: [
              {name: 'turnover',               function: 'value.turnover'},
              {name: 'payed',                  function: 'value.payed'},
              {name: 'cost',                   function: 'value.cost'},
              {name: 'product_name',           function: 'value.product_name'},
              {name: 'holding_name',           function: 'value.holding_name'},
              {name: 'campaign_name',          function: 'value.campaign_name'},
              {name: 'campaign_id',            function: 'value.campaign_id'},
              {name: 'ad_group_name',          function: 'value.ad_group_name'},
              {name: 'ad_group_id',            function: 'value.ad_group_id'},
              {name: 'conversions_backend',    function: 'value.conversions_backend'},
              {name: 'conversions_adwords',    function: 'value.conversions_adwords'},
              {name: 'worked',                 function: 'value.worked'},
              {name: 'qualified',              function: 'value.qualified'},
              {name: 'partner',                function: 'value.partner'},
              {name: 'clicks',                 function: '0'},
              {name: 'ad_group_status',        function: 'value.ad_group_status'}
            ]
          },

          misc: {
            database:           'kp',
            input_collection:   'tmp.adwords_db_1',
            output_collection:  'tmp.adwords_db_2'
          },

          query: {
            datetime_fields: ['created_at']
          }
        }

        KP_ADWORDS_DB_3 = {
          map: {
            keys: [
              {name: 'ad_group_ad_id',           function: 'value.ad_id'}
            ],
            values: [
              {name: 'product_name',             function: 'value.campaign_product'},
              {name: 'holding_name',             function: 'value.campaign_holding'},
              {name: 'campaign_name',            function: 'value.campaign_name'},
              {name: 'campaign_id',              function: 'value.campaign_id'},
              {name: 'ad_group_name',            function: 'value.ad_group_name'},
              {name: 'ad_group_id',              function: 'value.ad_group_id'},
              {name: 'cost',                     function: 'value.ad_cost_micro_amount / 1000000.0'},
              {name: 'turnover',                 function: '0'},
              {name: 'conversions_adwords',      function: 'value.ad_stat_conversions'},
              {name: 'conversions_backend',      function: '0'},
              {name: 'payed',                    function: '0'},
              {name: 'worked',                   function: '0'},
              {name: 'qualified',                function: '0'},
              {name: 'partner',                  function: 'null'},
              {name: 'ad_group_status',          function: 'value.ad_group_status'}
            ]
          },

          reduce: {
            values: [
              {name: 'cost'},
              {name: 'turnover'},
              {name: 'conversions_adwords'},
              {name: 'conversions_backend'},
              {name: 'product_name',             function: 'value.product_name'},
              {name: 'campaign_name',            function: 'value.campaign_name'},
              {name: 'campaign_id',              function: 'value.campaign_id'},
              {name: 'ad_group_name',            function: 'value.ad_group_name'},
              {name: 'ad_group_id',              function: 'value.ad_group_id'},
              {name: 'holding_name',             function: 'value.holding_name'},
              {name: 'payed',                    function: 'value.payed'},
              {name: 'worked'},
              {name: 'qualified'},
              {name: 'partner',                  function: 'partner'},
              {name: 'ad_group_status',          function: 'ad_group_status'}
            ],
            code: {
              text:  <<-JS
                          var turnover			      = 0;
                          var cost			          = 0;
                          var conversions_adwords	= 0;
                          var conversions_backend	= 0;
                          //var cr2                 = 0;
                          //var target_cpa          = 0;
                          var worked              = 0;
                          var qualified           = 0;
                          var partner             = null;
                          var ad_group_status     = null;

                          values.forEach(function(v){
                            cost     		        += v.cost;
                            turnover 		        += v.turnover;
                            conversions_adwords	+= v.conversions_adwords;
                            conversions_backend	+= v.conversions_backend;
                            // all but one entry should be 0, so this should work
                            //cr2                 += v.cr2;
                            //target_cpa          += v.target_cpa;
                            worked              += v.worked;
                            qualified           += v.qualified;
                            if(partner == null && v.partner != null && v.partner != ''){partner = v.partner;};
                            if(ad_group_status == null && v.ad_group_status != null && v.ad_group_status != ''){ad_group_status = v.ad_group_status;};
                          });
                        JS
            }
          },
          finalize: {
            values: [
              {name: 'turnover',               function: 'value.turnover'},
              {name: 'payed',                  function: 'value.payed'},
              {name: 'cost',                   function: 'value.cost'},
              {name: 'product_name',           function: 'value.product_name'},
              {name: 'holding_name',           function: 'value.holding_name'},
              {name: 'campaign_name',          function: 'value.campaign_name'},
              {name: 'campaign_id',            function: 'value.campaign_id'},
              {name: 'ad_group_name',          function: 'value.ad_group_name'},
              {name: 'ad_group_id',            function: 'value.ad_group_id'},
              {name: 'conversions_backend',    function: 'value.conversions_backend'},
              {name: 'conversions_adwords',    function: 'value.conversions_adwords'},
              {name: 'worked',                 function: 'value.worked'},
              {name: 'qualified',              function: 'value.qualified'},
              {name: 'partner',                function: 'value.partner'},
              {name: 'ad_group_status',        function: 'value.ad_group_status'}

            ]
          },

          misc: {
            database:           'kp',
            input_collection:   'adwords_early_warning_staging',
            output_collection:  'tmp.adwords_db_2',
            output_operation:   'reduce',
            filter_data:        true
          },

          query: {
            datetime_fields: ['ad_from']
          }
        }

        KP_ADWORDS_DB_4 = {
          map: {
            keys: [
              {name: 'holding_name',           function: 'value.holding_name'},
              {name: 'ad_group_id',            function: 'value.ad_group_id'},
              {name: 'campaign_id',            function: 'value.campaign_id'}
            ],
            values: [
              {name: 'turnover',               function: 'value.turnover'},
              {name: 'payed',                  function: 'value.payed'},
              {name: 'cost',                   function: 'value.cost'},
              {name: 'product_name',           function: 'value.product_name'},
              {name: 'campaign_name',          function: 'value.campaign_name'},
              {name: 'ad_group_name',          function: 'value.ad_group_name'},
              {name: 'conversions_backend',    function: 'value.conversions_backend'},
              {name: 'conversions_adwords',    function: 'value.conversions_adwords'},
              {name: 'worked',                 function: 'value.worked'},
              {name: 'qualified',              function: 'value.qualified'},
              {name: 'ad_group_status',        function: 'value.ad_group_status'}
            ],
          },

          reduce: {
            values: [
              {name: 'turnover'},
              {name: 'payed'},
              {name: 'cost'},
              {name: 'product_name',           function: 'value.product_name'},
              {name: 'campaign_name',          function: 'value.campaign_name'},
              {name: 'ad_group_name',          function: 'value.ad_group_name'},
              {name: 'conversions_backend'},
              {name: 'conversions_adwords'},
              {name: 'worked'},
              {name: 'qualified'},
              {name: 'ad_group_status',        function: 'value.ad_group_status'}
            ],
            code: {
              text:  <<-JS
                          var turnover			      = 0;
                          var cost			          = 0;
                          var conversions_adwords	= 0;
                          var conversions_backend	= 0;
                          var worked              = 0;
                          var qualified           = 0;
                          var payed               = 0;

                          values.forEach(function(v){
                            cost     		        += v.cost;
                            turnover 		        += v.turnover;
                            conversions_adwords	+= v.conversions_adwords;
                            conversions_backend	+= v.conversions_backend;
                            worked              += v.worked;
                            qualified           += v.qualified;
                            payed               += v.payed;
                          });
                        JS
            }
          },

          finalize: {
            values: [
              {name: 'campaign_name',          function: 'value.campaign_name'},
              {name: 'ad_group_name',          function: 'value.ad_group_name'},
              {name: 'ad_group_status',        function: 'value.ad_group_status'},
              {name: 'product_name',           function: 'value.product_name'},
              {name: 'turnover',               function: 'value.turnover'},
              {name: 'adwords_cost',           function: 'value.cost'},
              {name: 'conversions_backend',    function: 'value.conversions_backend'},
              {name: 'conversions_adwords',    function: 'value.conversions_adwords'},
              {name: 'worked',                 function: 'value.worked'},
              {name: 'qualified',              function: 'value.qualified'},
              {name: 'db',                     function: 'db'},
              {name: 'rel_db',                 function: 'rel_db'},
              {name: 'db2',                    function: 'db2'},
              {name: 'target_cpa',             function: 'target_cpa'},
              {name: 'current_cpa',            function: 'current_cpa'},
              {name: 'cr2',                    function: 'cr2'},
              {name: 'qual_cost',              function: 'qual_cost'},
              {name: 'payed',                  function: 'value.payed'}
            ],

            code: {
              text:  <<-JS
                          target_cpa 	  = (value.turnover / value.conversions_backend) / 2;
                          cr2           = value.qualified / value.worked;
                          db         	  = value.turnover - value.cost;
                          rel_db        = (db/value.cost);
                          current_cpa 	= value.cost / value.conversions_backend;
                          qual_cost     = value.qualified*6;
                          db2           = db - qual_cost;
                        JS
            }
          },

          misc: {
            database:           'kp',
            input_collection:   'tmp.adwords_db_2',
            output_collection:  'adwords_db'
          }
        }

        KP_OPTIMIZE_1 = {
          map: {
            keys: [
              {name: 'ad_group_ad_id',           function: 'value.ad_id'}
            ],
            values: [
              {name: 'product_name',             function: 'value.campaign_product'},
              {name: 'holding_name',             function: 'value.campaign_holding'},
              {name: 'campaign_name',            function: 'value.campaign_name'},
              {name: 'partner',                  function: 'value.ad_partner'},
              {name: 'campaign_id',              function: 'value.campaign_id'},
              {name: 'ad_group_name',            function: 'value.ad_group_name'},
              {name: 'ad_group_id',              function: 'value.ad_group_id'},
              {name: 'cost',                     function: 'value.ad_cost_micro_amount / 1000000.0'},
              {name: 'turnover',                 function: '0'},
              {name: 'conversions_adwords',      function: 'value.ad_stat_conversions'},
              {name: 'conversions_backend',      function: '0'},
              {name: 'payed',                    function: '0'},
              {name: 'worked',                   function: '0'},
              {name: 'qualified',                function: '0'},
              {name: 'clicks',                   function: 'value.ad_stat_clicks'}
            ]
          },

          reduce: {
            values: [
              {name: 'product_name',             function: 'value.product_name'},
              {name: 'campaign_name',            function: 'value.campaign_name'},
              {name: 'campaign_id',              function: 'value.campaign_id'},
              {name: 'ad_group_name',            function: 'value.ad_group_name'},
              {name: 'ad_group_id',              function: 'value.ad_group_id'},
              {name: 'holding_name',             function: 'value.holding_name'},
              {name: 'partner',                  function: 'value.partner'},
              {name: 'cost'},
              {name: 'turnover'},
              {name: 'conversions_adwords'},
              {name: 'conversions_backend'},
              {name: 'payed'},
              {name: 'worked'},
              {name: 'qualified'},
              {name: 'clicks'},
            ],
            code: {
              text:  <<-JS
                          var turnover            = 0;
                          var cost                = 0;
                          var conversions_adwords = 0;
                          var conversions_backend = 0;
                          var payed               = 0;
                          var worked              = 0;
                          var qualified           = 0;
                          var clicks              = 0;

                          values.forEach(function(v){
                            cost                += v.cost;
                            turnover            += v.turnover;
                            conversions_adwords += v.conversions_adwords;
                            conversions_backend += v.conversions_backend;
                            worked              += v.worked;
                            qualified           += v.qualified;
                            clicks              += v.clicks;
                            payed               += v.payed;
                          });
                        JS
            }
          },
          finalize: {
            values: [
              {name: 'turnover',               function: 'value.turnover'},
              {name: 'payed',                  function: 'value.payed'},
              {name: 'cost',                   function: 'value.cost'},
              {name: 'product_name',           function: 'value.product_name'},
              {name: 'holding_name',           function: 'value.holding_name'},
              {name: 'partner',                function: 'value.partner'},
              {name: 'campaign_name',          function: 'value.campaign_name'},
              {name: 'campaign_id',            function: 'value.campaign_id'},
              {name: 'ad_group_name',          function: 'value.ad_group_name'},
              {name: 'ad_group_id',            function: 'value.ad_group_id'},
              {name: 'conversions_backend',    function: 'value.conversions_backend'},
              {name: 'conversions_adwords',    function: 'value.conversions_adwords'},
              {name: 'worked',                 function: 'value.worked'},
              {name: 'qualified',              function: 'value.qualified'},
              {name: 'clicks',                 function: 'value.clicks'},
              {name: 'leads_bought',           function: '0'},
              {name: 'leads_proposed',         function: '0'},
              {name: 'leads_for_sale',         function: '0'}
            ]
          },

          misc: {
            database:           'kp',
            input_collection:   'adwords_early_warning_staging',
            output_collection:  'tmp.optimize_sheet_1',
            filter_data:        true
          },

          query: {
            datetime_fields: ['ad_from']
          }
        }

        KP_OPTIMIZE_2 = {
          map: {
            keys: [
              {name: 'inquiry_id',           function: 'value.inquiry_id', exchangeable: false}
            ],
            values: [
              {name: 'inquiry_id',           function: 'value.inquiry_id'},
              {name: 'turnover'},
              {name: 'payed'},
              {name: 'created_at',           function: 'value.created_at'},
              {name: 'ad_group_ad_id',       function: 'value.ad_group_ad_id'},
              {name: 'status_id',            function: 'value.status_id'},
              {name: 'partner',              function: '""'},
              {name: 'leads_bought'},
              {name: 'leads_proposed',       function: '1'},
              {name: 'leads_for_sale',       function: 'value.number_leads'}

            ],
            code: {
              text:  <<-JS
                      var turnover 		  = 0;
                      var payed 		    = 0;
                      var leads_bought  = 0;

                      if(value.lead_status_id == 1){turnover = value.leaddetails_price};
                      if(value.lead_status_id == 1){leads_bought = 1;};
                      if(value.leaddetails_billing_status_id == 2){payed = value.leaddetails_price};
                    JS
            }
          },

          reduce: {
            values: [
              {name: 'inquiry_id',           function: 'value.inquiry_id'},
              {name: 'turnover'},
              {name: 'payed'},
              {name: 'created_at',           function: 'value.created_at'},
              {name: 'ad_group_ad_id',       function: 'value.ad_group_ad_id'},
              {name: 'status_id',            function: 'value.status_id'},
              {name: 'partner',              function: 'value.partner'},
              {name: 'leads_bought'},
              {name: 'leads_proposed'},
              {name: 'leads_for_sale',       function: 'value.leads_for_sale'}
            ],
            code: {
              text:  <<-JS
                      var turnover          = 0;
                      var payed             = 0;
                      var leads_proposed    = 0;
                      var leads_bought      = 0;

                      values.forEach(function(v){
                        turnover 	      += v.turnover;
                        payed 	        += v.payed;
                        leads_proposed  += v.leads_proposed;
                        leads_bought    += v.leads_bought;
                      });
                    JS
            }
          },

          finalize: {
              values: [
                {name: 'inquiry_id',           function: 'value.inquiry_id'},
                {name: 'turnover',             function: 'value.turnover'},
                {name: 'payed',                function: 'value.payed'},
                {name: 'created_at',           function: 'value.created_at'},
                {name: 'ad_group_ad_id',       function: 'value.ad_group_ad_id'},
                {name: 'status_id',            function: 'value.status_id'},
                {name: 'worked'},
                {name: 'qualified'},
                {name: 'partner',              function: 'value.partner'},
                {name: 'conversions_backend',  function: '1'},
                {name: 'leads_bought',         function: 'value.leads_bought'},
                {name: 'leads_proposed',       function: 'value.leads_proposed'},
                {name: 'leads_for_sale'}
              ],
              code: {
                text:  <<-JS
                        worked    = 1;
                        qualified = 1;
                        leads_for_sale = 0;

                        if(value.status_id == 0){worked=0;};
                        if(value.status_id != 1){qualified=0;};
                        if(value.status_id == 1){leads_for_sale=value.leads_for_sale;};
                      JS
              },
          },

          misc: {
            database:           'kp',
            input_collection:   'kp_backend_staging',
            output_collection:  'tmp.optimize_sheet_2',
            filter_data:        true
          },

          query: {
            datetime_fields: ['created_at']
          }
        }

        KP_OPTIMIZE_3 = {
          map: {
            keys: [
              {name: 'ad_group_ad_id',         function: 'value.ad_group_ad_id'}
            ],
            values: [
              {name: 'turnover',               function: 'value.turnover'},
              {name: 'payed',                  function: 'value.payed'},
              {name: 'cost',                   function: 'value.cost'},
              {name: 'product_name',           function: 'null'},
              {name: 'holding_name',           function: 'null'},
              {name: 'campaign_name',          function: 'null'},
              {name: 'campaign_id',            function: 'null'},
              {name: 'ad_group_name',          function: 'null'},
              {name: 'ad_group_id',            function: 'null'},
              {name: 'conversions_adwords',    function: 'value.conversions_adwords'},
              {name: 'conversions_backend',    function: 'value.conversions_backend'},
              {name: 'worked',                 function: 'value.worked'},
              {name: 'qualified',              function: 'value.qualified'},
              {name: 'partner',                function: 'value.partner'},
              {name: 'clicks',                 function: 'value.clicks'},
              {name: 'leads_bought',           function: 'value.leads_bought'},
              {name: 'leads_proposed',         function: 'value.leads_proposed'},
              {name: 'leads_for_sale',         function: 'value.leads_for_sale'}
            ]
          },

          reduce: {
            values: [
              {name: 'turnover'},
              {name: 'cost'},
              {name: 'product_name'},
              {name: 'holding_name'},
              {name: 'campaign_name'},
              {name: 'campaign_id'},
              {name: 'ad_group_name'},
              {name: 'ad_group_id'},
              {name: 'conversions_backend'},
              {name: 'conversions_adwords'},
              {name: 'worked'},
              {name: 'qualified'},
              {name: 'partner'},
              {name: 'clicks'},
              {name: 'leads_bought'},
              {name: 'leads_proposed'},
              {name: 'leads_for_sale'}
            ],

            code: {
              text:  <<-JS
                      var turnover			      = 0;
                      var payed               = 0;
                      var cost			          = 0;
                      var conversions_backend	= 0;
                      var conversions_adwords = 0;
                      var worked              = 0;
                      var qualified           = 0;
                      var clicks              = 0;
                      var leads_proposed      = 0;
                      var leads_bought        = 0;
                      var leads_for_sale      = 0;

                      var partner             = null;
                      var product_name        = null;
                      var holding_name        = null;
                      var campaign_name       = null;
                      var campaign_id         = null;
                      var ad_group_name       = null;
                      var ad_group_id         = null;

                      values.forEach(function(v){
                        cost     		        += v.cost;
                        payed               += v.payed;
                        turnover 		        += v.turnover;
                        conversions_backend	+= v.conversions_backend;
                        conversions_adwords += v.conversions_adwords;
                        worked              += v.worked;
                        qualified           += v.qualified;
                        clicks              += v.clicks;
                        leads_bought        += v.leads_bought;
                        leads_proposed      += v.leads_proposed;
                        leads_for_sale      += v.leads_for_sale;

                        if(partner == null && v.partner != null && v.partner != ''){partner = v.partner;};  
                        if(product_name == null && v.product_name != null){product_name = v.product_name;};
                        if(holding_name == null && v.holding_name != null){holding_name = v.holding_name;};
                        if(campaign_name == null && v.campaign_name != null){campaign_name = v.campaign_name;};
                        if(campaign_id == null && v.campaign_id != null){campaign_id = v.campaign_id;};
                        if(ad_group_name == null && v.ad_group_name != null){ad_group_name = v.ad_group_name;};
                        if(ad_group_id == null && v.ad_group_id != null){ad_group_id = v.ad_group_id;};

                      });
                    JS
            }
          },

          finalize: {
            values: [
              {name: 'turnover',               function: 'value.turnover'},
              {name: 'payed',                  function: 'value.payed'},
              {name: 'cost',                   function: 'value.cost'},
              {name: 'product_name',           function: 'value.product_name'},
              {name: 'holding_name',           function: 'value.holding_name'},
              {name: 'campaign_name',          function: 'value.campaign_name'},
              {name: 'campaign_id',            function: 'value.campaign_id'},
              {name: 'ad_group_name',          function: 'value.ad_group_name'},
              {name: 'ad_group_id',            function: 'value.ad_group_id'},
              {name: 'conversions_backend',    function: 'value.conversions_backend'},
              {name: 'conversions_adwords',    function: 'value.conversions_adwords'},
              {name: 'worked',                 function: 'value.worked'},
              {name: 'qualified',              function: 'value.qualified'},
              {name: 'partner',                function: 'value.partner'},
              {name: 'clicks',                 function: 'value.clicks'},
              {name: 'leads_bought',           function: 'value.leads_bought'},
              {name: 'leads_proposed',         function: 'value.leads_proposed'},
              {name: 'leads_for_sale',         function: 'value.leads_for_sale'}
            ]
          },

          misc: {
            database: 'kp',
            input_collection: 'tmp.optimize_sheet_2',
            output_collection: 'tmp.optimize_sheet_1',
            output_operation: 'reduce',
            filter_data: true
          },

          query: {
            datetime_fields: ['created_at'],
            condition: [{field: 'value.ad_group_ad_id', value: [nil], negative: true}],
          }
        }

        KP_OPTIMIZE_4 = {
          map: {
            keys: [
              {name: 'partner',                function: 'value.partner'}
            ],
            values: [
              {name: 'partner',                function: 'value.partner'},
              {name: 'holding_name',           function: 'value.holding_name'},
              {name: 'product_name',           function: 'value.product_name'},
              {name: 'turnover',               function: 'value.turnover'},
              {name: 'cost',                   function: 'value.cost'},
              {name: 'conversions_backend',    function: 'value.conversions_backend'},
              {name: 'conversions_adwords',    function: 'value.conversions_adwords'},
              {name: 'qualified',              function: 'value.qualified'},
              {name: 'worked',                 function: 'value.worked'},
              {name: 'clicks',                 function: 'value.clicks'},
              {name: 'leads_bought',           function: 'value.leads_bought'},
              {name: 'leads_proposed',         function: 'value.leads_proposed'},
              {name: 'leads_for_sale',         function: 'value.leads_for_sale'}
            ],
          },

          reduce: {
            values: [
              {name: 'partner',                function: 'value.partner'},
              {name: 'holding_name',           function: 'value.holding_name'},
              {name: 'product_name',           function: 'value.product_name'},
              {name: 'turnover'},
              {name: 'cost'},
              {name: 'conversions_backend'},
              {name: 'conversions_adwords'},
              {name: 'qualified'},
              {name: 'worked'},
              {name: 'clicks'},
              {name: 'leads_bought'},
              {name: 'leads_proposed'},
              {name: 'leads_for_sale'}
            ],
            code: {
              text:  <<-JS
                      var turnover			      = 0;
                      var cost			          = 0;
                      var conversions_adwords	= 0;
                      var conversions_backend	= 0;
                      var worked              = 0;
                      var qualified           = 0;
                      var clicks              = 0;
                      var leads_proposed      = 0;
                      var leads_bought        = 0;
                      var leads_for_sale      = 0;

                      values.forEach(function(v){
                        cost     		        += v.cost;
                        turnover 		        += v.turnover;
                        conversions_adwords	+= v.conversions_adwords;
                        conversions_backend	+= v.conversions_backend;
                        worked              += v.worked;
                        qualified           += v.qualified;
                        clicks              += v.clicks;
                        leads_proposed      += v.leads_proposed;
                        leads_bought        += v.leads_bought;
                        leads_for_sale      += v.leads_for_sale;
                      });
                    JS
            }
          },

          finalize: {
            values: [
              {name: 'partner',                function: 'value.partner'},
              {name: 'holding_name',           function: 'value.holding_name'},
              {name: 'product_name',           function: 'value.product_name'},
              {name: 'turnover',               function: 'Math.round(value.turnover*100)/100'},
              {name: 'adwords_cost',           function: 'Math.round(value.cost*100)/100'},
              {name: 'conversions_backend',    function: 'value.conversions_backend'},
              {name: 'conversions_adwords',    function: 'value.conversions_adwords'},
              {name: 'qualified',              function: 'value.qualified'},
              {name: 'db',                     function: 'Math.round(db*100)/100'},
              {name: 'db2',                    function: 'Math.round(db2*100)/100'},
              {name: 'cr2',                    function: 'Math.round(cr2*1000)/10'},
              {name: 'qual_cost',              function: 'Math.round(qual_cost*100)/100'},
              {name: 'clicks',                 function: 'value.clicks'},
              {name: 'cr1',                    function: 'Math.round(cr1*1000)/10'},
              {name: 'lar',                    function: 'Math.round(lar*1000)/10'}
            ],

              code: {
                text:  <<-JS
                        db         	  = value.turnover - value.cost;
                        qual_cost     = value.qualified*6;
                        db2           = db - qual_cost;
                        cr2           = value.qualified / value.worked;
                        cr1           = value.conversions_backend / value.clicks;
                        lar           = value.leads_bought / value.leads_for_sale;
                      JS
              }
          },

          misc: {
            database: 'kp',
            input_collection: 'tmp.optimize_sheet_1',
            output_collection: 'optimize_sheet',
            id: 'o4'
          }
        }

        KP_PRODUKTANFRAGEN = {
          :map => {
            :keys => [
              {:name => 'inquiry_id',           :function => 'value.inquiry_id', :exchangeable => false}
            ],
            :values => [
              {:name => 'inquiry_id',           :function => 'value.inquiry_id'},
              {:name => 'turnover'},
              {:name => 'payed'},
              {:name => 'created_at',           :function => 'value.created_at'},
              {:name => 'ad_group_ad_id',       :function => 'value.ad_group_ad_id'},
              {:name => 'status_id',            :function => 'value.status_id'},
              {:name => 'extended_status_id',   :function => 'value.extended_status_id'},
              {:name => 'partner',              :function => 'value.partner'},
              {:name => 'qualifier',            :function => 'value.qualifier'},
              {:name => 'product_name',         :function => 'value.product_name'},
              {:name => 'product_id',           :function => 'value.product_id'}
            ],
            :code => {
              :text =>  <<-JS
                          var turnover 		= 0;
                          var payed 		  = 0;

                          if(value.lead_status_id == 1){turnover = value.leaddetails_price};
                          if(value.leaddetails_billing_status_id == 2){payed = value.leaddetails_price};
                        JS
            }
          },

          :reduce => {
            :values => [
              {:name => 'inquiry_id',           :function => 'value.inquiry_id'},
              {:name => 'turnover'},
              {:name => 'payed'},
              {:name => 'created_at',           :function => 'value.created_at'},
              {:name => 'ad_group_ad_id',       :function => 'value.ad_group_ad_id'},
              {:name => 'status_id',            :function => 'value.status_id'},
              {:name => 'extended_status_id',   :function => 'value.extended_status_id'},
              {:name => 'partner',              :function => 'value.partner'},
              {:name => 'qualifier',            :function => 'value.qualifier'},
              {:name => 'product_name',         :function => 'value.product_name'},
              {:name => 'product_id',           :function => 'value.product_id'}
            ],
            :code => {
              :text =>  <<-JS
                          var turnover  = 0;
                          var payed     = 0;

                          values.forEach(function(v){
                            turnover 	+= v.turnover;
                            payed 	  += v.payed;
                          });
                        JS
            }
          },

          :finalize => {
            :values => [
              {:name => 'inquiry_id',           :function => 'value.inquiry_id'},
              {:name => 'turnover',             :function => 'value.turnover'},
              {:name => 'payed',                :function => 'value.payed'},
              {:name => 'created_at',           :function => 'value.created_at'},
              {:name => 'ad_group_ad_id',       :function => 'value.ad_group_ad_id'},
              {:name => 'status_id',            :function => 'value.status_id'},
              {:name => 'extended_status_id',   :function => 'value.extended_status_id'},
              {:name => 'worked'},
              {:name => 'qualified'},
              {:name => 'not_qualified'},
              {:name => 'not_qualified_good_reason'},
              {:name => 'partner',              :function => 'value.partner'},
              {:name => 'qualifier',            :function => 'value.qualifier'},
              {:name => 'product_name',         :function => 'value.product_name'},
              {:name => 'product_id',           :function => 'value.product_id'}
            ],
            :code => {
              :text =>  <<-JS
                          worked                      = 1;
                          qualified                   = 1;
                          not_qualified               = 0;
                          not_qualified_good_reason   = 0;

                          if(value.status_id == 0){worked=0};
                          if(value.status_id != 1){qualified=0};
                          if(value.status_id == 2){
                            not_qualified = 1;
                            if(value.extended_status_id == 2001 || value.extended_status_id == 2010 || value.extended_status_id == 2016 || value.extended_status_id == 2013 || value.extended_status_id == 2014 || value.extended_status_id == 2011 || value.extended_status_id == 2012 || value.extended_status_id == 2005 ){
                              not_qualified_good_reason = 1;
                            };
                          };
                        JS
            },
          },

          :misc => {
            :database           => 'kp',
            :input_collection   => 'kp_backend_staging',
            :output_collection  => 'tmp.cr2_comparison_1'
          },

          :query => {
            :datetime_fields => ['created_at']
          }
        }

        KP_CR2_COMPARISON_1 = {
          map: {
            keys: [
              {name: 'qualifier',                     function: 'value.qualifier'},
              {name: 'product_name',                  function: 'value.product_name'}
            ],
            values: [
              {name: 'turnover',                      function: 'value.turnover'},
              {name: 'payed',                         function: 'value.payed'},
              {name: 'qualified',                     function: 'value.qualified'},
              {name: 'not_qualified',                 function: 'value.not_qualified'},
              {name: 'not_qualified_good_reason',     function: 'value.not_qualified_good_reason'},
              {name: 'product_id',                    function: 'value.product_id'}
            ]
          },

          reduce: {
            values: [
              {name: 'turnover'},
              {name: 'payed'},
              {name: 'qualified'},
              {name: 'not_qualified'},
              {name: 'not_qualified_good_reason'},
              {name: 'product_id',                    function: 'value.product_id'}
            ],
            code: {
              text:  <<-JS
                          var turnover                    = 0;
                          var payed                       = 0;
                          var qualified                   = 0;
                          var not_qualified               = 0;
                          var not_qualified_good_reason   = 0;

                          values.forEach(function(v){
                            turnover                      += v.turnover;
                            payed                         += v.payed;
                            qualified                     += v.qualified;
                            not_qualified                 += v.not_qualified;
                            not_qualified_good_reason     += v.not_qualified_good_reason;
                          });
                        JS
            }
          },

          finalize: {
            values: [
              {name: 'qualified',                     function: 'value.qualified'},
              {name: 'not_qualified',                 function: 'value.not_qualified'},
              {name: 'total_pafs'},
              {name: 'cr2'},
              {name: 'not_qualified_good_reason',     function: 'value.not_qualified_good_reason'},
              {name: 'not_qualified_no_good_reason'},
              {name: 'cr2_real'},
              {name: 'm'},
              {name: 'money_burner'}
            ],
            code: {
              text: <<-JS
                      cr2_target                    = 75.0;
                      if( value.product_id == 30 || value.product_id == 29){cr2_target = 85.0;};
                      if( value.product_id == 558 ){cr2_target = 50.0;};

                      revenue_per_paf               = 68;
                      not_qualified_no_good_reason  = value.not_qualified - value.not_qualified_good_reason;
                      total_pafs                    = value.qualified + value.not_qualified;
                      cr2                           = Math.round((value.qualified / total_pafs)*10000)/100;
                      cr2_real                      = Math.round((value.qualified / (value.qualified + not_qualified_no_good_reason))*10000)/100;
                      m                             = (((cr2_target - cr2_real + 100)/100)*value.qualified)-value.qualified;
                      m                             = Math.round(m*100)/100;
                      if( m < 0){m=0;};
                      money_burner                  = Math.round((m * revenue_per_paf)*100)/100;

                    JS
            },
          },

          misc: {
            database:           'kp',
            input_collection:   'tmp.cr2_comparison_1',
            output_collection:  'cr2_comparison'
          }
        }

        KP_OPTIMIZE_SEO_1 = {
          map: {
            keys: [
              {name: 'inquiry_id',           function: 'value.inquiry_id', exchangeable: false}
            ],
            values: [
              {name: 'inquiry_id',           function: 'value.inquiry_id'},
              {name: 'turnover'},
              {name: 'payed'},
              {name: 'created_at',           function: 'value.created_at'},
              {name: 'ad_group_ad_id',       function: 'value.ad_group_ad_id'},
              {name: 'status_id',            function: 'value.status_id'},
              {name: 'partner',              function: 'value.partner'},
              {name: 'leads_bought'},
              {name: 'leads_proposed',       function: '1'},
              {name: 'leads_for_sale',       function: 'value.number_leads'},
              {name: 'product_name',         function: 'value.product_name'}

            ],
            code: {
              text:  <<-JS
                      var turnover 		  = 0;
                      var payed 		    = 0;
                      var leads_bought  = 0;

                      if(value.lead_status_id == 1){turnover = value.leaddetails_price};
                      if(value.lead_status_id == 1){leads_bought = 1;};
                      if(value.leaddetails_billing_status_id == 2){payed = value.leaddetails_price};
                    JS
            }
          },

          reduce: {
            values: [
              {name: 'inquiry_id',           function: 'value.inquiry_id'},
              {name: 'turnover'},
              {name: 'payed'},
              {name: 'created_at',           function: 'value.created_at'},
              {name: 'ad_group_ad_id',       function: 'value.ad_group_ad_id'},
              {name: 'status_id',            function: 'value.status_id'},
              {name: 'partner',              function: 'value.partner'},
              {name: 'leads_bought'},
              {name: 'leads_proposed'},
              {name: 'leads_for_sale',       function: 'value.leads_for_sale'},
              {name: 'product_name',         function: 'value.product_name'}
            ],
            code: {
              text:  <<-JS
                      var turnover          = 0;
                      var payed             = 0;
                      var leads_proposed    = 0;
                      var leads_bought      = 0;

                      values.forEach(function(v){
                        turnover 	      += v.turnover;
                        payed 	        += v.payed;
                        leads_proposed  += v.leads_proposed;
                        leads_bought    += v.leads_bought;
                      });
                    JS
            }
          },

          finalize: {
            values: [
              {name: 'inquiry_id',           function: 'value.inquiry_id'},
              {name: 'turnover',             function: 'value.turnover'},
              {name: 'payed',                function: 'value.payed'},
              {name: 'created_at',           function: 'value.created_at'},
              {name: 'ad_group_ad_id',       function: 'value.ad_group_ad_id'},
              {name: 'status_id',            function: 'value.status_id'},
              {name: 'worked'},
              {name: 'qualified'},
              {name: 'partner',              function: 'value.partner'},
              {name: 'product_name',         function: 'value.product_name'},
              {name: 'conversions_backend',  function: '1'},
              {name: 'leads_bought',         function: 'value.leads_bought'},
              {name: 'leads_proposed',       function: 'value.leads_proposed'},
              {name: 'leads_for_sale'},
              {name: 'cost',                 function: '0'}
            ],
            code: {
              text:  <<-JS
                        worked    = 1;
                        qualified = 1;
                        leads_for_sale = 0;

                        if(value.status_id == 0){worked=0;};
                        if(value.status_id != 1){qualified=0;};
                        if(value.status_id == 1){leads_for_sale=value.leads_for_sale;};
                      JS
            },
          },

          misc: {
            database:           'kp',
            input_collection:   'kp_backend_staging',
            output_collection:  'tmp.optimize_sheet_seo_1',
            filter_data:        true,
            id:                 'os1'
          },

          query: {
            datetime_fields: ['created_at'],
            condition: [{field: 'value.ad_group_ad_id', value: 'seo'}],
          }
        }

        KP_OPTIMIZE_SEO_2 = {
          map: {
            keys: [
              {name: 'partner',                function: 'value.partner'}
            ],
            values: [
              {name: 'partner',                function: 'value.partner'},
              {name: 'product_name',           function: 'value.product_name'},
              {name: 'turnover',               function: 'value.turnover'},
              {name: 'cost',                   function: 'value.cost'},
              {name: 'conversions_backend',    function: 'value.conversions_backend'},
              {name: 'qualified',              function: 'value.qualified'},
              {name: 'worked',                 function: 'value.worked'},
              {name: 'clicks',                 function: 'value.clicks'},
              {name: 'leads_bought',           function: 'value.leads_bought'},
              {name: 'leads_proposed',         function: 'value.leads_proposed'},
              {name: 'leads_for_sale',         function: 'value.leads_for_sale'},
              {name: 'cost',                   function: 'value.cost'}
            ],
          },

          reduce: {
            values: [
              {name: 'partner',                function: 'value.partner'},
              {name: 'product_name',           function: 'value.product_name'},
              {name: 'turnover'},
              {name: 'cost'},
              {name: 'conversions_backend'},
              {name: 'qualified'},
              {name: 'worked'},
              {name: 'clicks'},
              {name: 'leads_bought'},
              {name: 'leads_proposed'},
              {name: 'leads_for_sale'}
            ],
            code: {
              text:  <<-JS
                        var turnover			      = 0;
                        var cost			          = 0;
                        var conversions_backend	= 0;
                        var worked              = 0;
                        var qualified           = 0;
                        var clicks              = 0;
                        var leads_proposed      = 0;
                        var leads_bought        = 0;
                        var leads_for_sale      = 0;

                        values.forEach(function(v){
                          cost     		        += v.cost;
                          turnover 		        += v.turnover;
                          conversions_backend	+= v.conversions_backend;
                          worked              += v.worked;
                          qualified           += v.qualified;
                          leads_proposed      += v.leads_proposed;
                          leads_bought        += v.leads_bought;
                          leads_for_sale      += v.leads_for_sale;
                        });
                      JS
            }
          },

          finalize: {
            values: [
              {name: 'partner',                function: 'value.partner'},
              {name: 'product_name',           function: 'value.product_name'},
              {name: 'turnover',               function: 'Math.round(value.turnover*100)/100'},
              {name: 'conversions_backend',    function: 'value.conversions_backend'},
              {name: 'qualified',              function: 'value.qualified'},
              {name: 'db',                     function: 'Math.round(db*100)/100'},
              {name: 'db2',                    function: 'Math.round(db2*100)/100'},
              {name: 'cr2',                    function: 'Math.round(cr2*1000)/10'},
              {name: 'qual_cost',              function: 'Math.round(qual_cost*100)/100'},
              {name: 'lar',                    function: 'Math.round(lar*1000)/10'}
            ],

            code: {
              text:  <<-JS
                      db         	  = value.turnover - value.cost;
                      qual_cost     = value.qualified*6;
                      db2           = db - qual_cost;
                      cr2           = value.qualified / value.worked;
                      lar           = value.leads_bought / value.leads_for_sale;
                    JS
            }
          },

          misc: {
            database: 'kp',
            input_collection: 'tmp.optimize_sheet_seo_1',
            output_collection: 'optimize_sheet_seo',
            id: 'os2'
          }
        }
      end
    end
  end
end