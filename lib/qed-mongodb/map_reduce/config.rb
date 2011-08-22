module Qed
  module Mongodb
    module MapReduce
      class Config
        KP_EW_1 =
            {
                :mapreduce_keys => [
                    # TODO: if the function == "value."#{name} I don't want to write it down
                    {:name => "campaign_product", :function => "value.campaign_product"}
                ],
                :mapreduce_values => [
                    {:name => "campaign_holding",     :function => "value.campaign_holding"},
                    {:name => "campaign_name",        :function => "value.campaign_name"},
                    {:name => "ad_conversions",       :function => "ad_conversions"},
                    {:name => "ad_cost",              :function => "ad_cost"},
                    {:name => "ad_impressions",       :function => "ad_impressions"}
                ],
                :finalize_values => [
                    {:name => "campaign_holding",     :function => "value.campaign_holding"},
                    {:name => "campaign_name",        :function => "value.campaign_name"},
                    {:name => "ad_conversions",       :function => "value.ad_conversions"},
                    {:name => "ad_cost",              :function => "value.ad_cost"},
                    {:name => "ad_impressions",       :function => "value.ad_impressions"}
                ],
                :database               => "kp",
                :base_collection        => "adwords_early_warning_staging",
                :mr_collection          => "mr_adwords_early_warning_staging",
                :query                  => nil,
                :map                    => Qed::Mongodb::MapReduce::Store::KP_EW_MAP1,
                :reduce                 => Qed::Mongodb::MapReduce::Store::KP_EW_REDUCE1,
                :finalize               => Qed::Mongodb::MapReduce::Store::KP_EW_FINALIZE1

            }
        KP_CBP_1 =
            {
                :mapreduce_keys => [
                    {:name => "inquiry_id", :function => "NumberLong(value.inquiry_id)"}
                  ],
                :mapreduce_values =>  [
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
                    {:name => "level",              :function => "value.level"}
                  ],
                :finalize_values => [
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
                :database             => "qed_production",
                :base_collection      => "inquiries",
                :mr_collection        => "mr_inquiries_jak4",
                :query                => nil,
                :map                  => Qed::Mongodb::MapReduce::Store::KP_CBP_MAP1,
                :reduce               => Qed::Mongodb::MapReduce::Store::KP_CBP_REDUCE1,
                :finalize             => Qed::Mongodb::MapReduce::Store::KP_CBP_FINALIZE1
            }

           KP_CBP_2 =
            {
                :mapreduce_keys => [
                    {:name => "product_name",     :function => "value.product_name"}
                  ],
                :mapreduce_values =>  [
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
                :finalize_values => [
                    {:name => "product_name",         :function => "value.product_name"},
                    {:name => "count",                :function => "value.count"},
                    {:name => "worked_on",            :function => "value.worked_on"},
                    {:name => "qualified",            :function => "value.qualified"},
                    {:name => "test",                 :function => "value.test"},
                    {:name => "turnover",             :function => "value.turnover"},
                    {:name => "payed",                :function => "value.payed"},
                    {:name => "product_uuid",         :function => "value.product_uuid"},
                    {:name => "inquiry_id",           :function => "value.inquiry_id"}
                ],
                :database             => "qed_production",
                :base_collection      => "mr_inquiries_jak4",
                :mr_collection        => "mr_suppa_jak4",
                :query      => nil,
                :map        => Qed::Mongodb::MapReduce::Store::KP_CBP_MAP2,
                :reduce     => Qed::Mongodb::MapReduce::Store::KP_CBP_REDUCE2,
                :finalize   => Qed::Mongodb::MapReduce::Store::KP_CBP_FINALIZE2
            }

           KP_CBC_2 =
            {
                :mapreduce_keys => [
                    {:name => "ag",               :function => "value.tracking_ag"}
                  ],
                :mapreduce_values =>  [
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
                :finalize_values => [
                    {:name => "tracking_ag",          :function => "value.tracking_ag"},
                    {:name => "count",                :function => "value.count"},
                    {:name => "worked_on",            :function => "value.worked_on"},
                    {:name => "qualified",            :function => "value.qualified"},
                    {:name => "test",                 :function => "value.test"},
                    {:name => "turnover",             :function => "value.turnover"},
                    {:name => "payed",                :function => "value.payed"},
                    {:name => "product_uuid",         :function => "value.product_uuid"},
                    {:name => "inquiry_id",           :function => "value.inquiry_id"}
                ],
                :database             => "qed_production",
                :base_collection      => "mr_inquiries_jak4",
                :mr_collection        => "mr_suppa_jak4",
                :query      => nil,
                :map        => Qed::Mongodb::MapReduce::Store::KP_CBP_MAP2,
                :reduce     => Qed::Mongodb::MapReduce::Store::KP_CBP_REDUCE2,
                :finalize   => Qed::Mongodb::MapReduce::Store::KP_CBP_FINALIZE2
            }

          KP_TRA_2 =
            {
                :mapreduce_keys => [
                    {:name => nil,                :function => "(value.product_name+domain+value.level)"}
                  ],
                :mapreduce_values =>  [
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
                :finalize_values => [
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
                ],
                :database             => "qed_production",
                :base_collection      => "mr_inquiries_jak4",
                :mr_collection        => "mr_suppa_jak4",
                :query      => nil,
                :map        => Qed::Mongodb::MapReduce::Store::KP_TRA_MAP2,
                :reduce     => Qed::Mongodb::MapReduce::Store::KP_TRA_REDUCE2,
                :finalize   => Qed::Mongodb::MapReduce::Store::KP_TRA_FINALIZE2
            }
      end
    end
  end
end

