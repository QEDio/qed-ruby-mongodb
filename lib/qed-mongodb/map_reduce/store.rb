module Qed
  module Mongodb
    module MapReduce
      class Store
        KP_CBP_MAP1 =
          <<-JS
              turnover = 0;
              payed = 0;

              if(value.lead_status_id == 1){turnover = value.leaddetails_price};
              if(value.leaddetails_billing_status_id == 2){payed = value.leaddetails_price};
          JS

        KP_CBP_REDUCE1 =
            <<-JS
                var turnover = 0;
                var payed = 0;

                values.forEach(function(v){
                  turnover += v.turnover;
                  payed += v.payed;
                });
            JS

        KP_CBP_FINALIZE1=
               <<-JS
                worked = 1;
                qualified = 1;
                test = 0;

                if(value.status_id == 0){worked=0};
                if(value.status_id == 4){test=1};
                if(value.status_id != 1){qualified=0};
              JS


        KP_CBP_MAP2 =
              <<-JS
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

        KP_CBP_REDUCE2 =
              <<-JS
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

        KP_CBP_FINALIZE2=
              <<-JS
              JS
      end
    end
  end
end
