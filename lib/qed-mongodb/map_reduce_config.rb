module Qed
  module Mongodb
    class MapReduceConfig
       KP_CBP_1 =
            {
                :key => {:name => "inquiry_id", :function => "NumberLong(value.inquiry_id)"},
                :mapreduce_values =>  [
                    {:name => "inquiry_id",           :function => "NumberLong(value.inquiry_id)"},
                    {:name => "status_id",            :function => "value.status_id"},
                    {:name => "turnover"},
                    {:name => "payed"},
                    {:name => "product_name",         :function => "value.product_name"},
                    {:name => "created_at",           :function => "value.created_at"},
                    {:name => "product_uuid",         :function => "value.product_uuid"},
                    {:name => "inquiry_id",           :function => "value.inquiry_id"},
                    {:name => "tracking_ag",          :function => "value.tracking_ag"}
                  ],
                :finalize_values => [
                    {:name => "inquiry_id", :function => "NumberLong(value.inquiry_id)"},
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
                    {:name => "tracking_ag",          :function => "value.tracking_ag"}
                ],
                :database             => "qed_production",
                :base_collection      => "inquiries",
                :mr_collection        => "mr_inquiries_jak4",
                :query                => nil,
                :map                  => Qed::Mongodb::MapReduceStore::KP_CBP_MAP1,
                :reduce               => Qed::Mongodb::MapReduceStore::KP_CBP_REDUCE1,
                :finalize             => Qed::Mongodb::MapReduceStore::KP_CBP_FINALIZE1
            }


           KP_CBP_2 =
            {
                :key => {:name => "product_name", :function => "value.product_name"},
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
                :map        => Qed::Mongodb::MapReduceStore::KP_CBP_MAP2,
                :reduce     => Qed::Mongodb::MapReduceStore::KP_CBP_REDUCE2,
                :finalize   => Qed::Mongodb::MapReduceStore::KP_CBP_FINALIZE2
            }

           KP_CBC_2 =
            {
                :key => {:name => "ag", :function => "value.tracking_ag"},
                :mapreduce_values =>  [
                    {:name => "tracking_ag",                   :function => "value.tracking_ag"},
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
                :map        => Qed::Mongodb::MapReduceStore::KP_CBP_MAP2,
                :reduce     => Qed::Mongodb::MapReduceStore::KP_CBP_REDUCE2,
                :finalize   => Qed::Mongodb::MapReduceStore::KP_CBP_FINALIZE2
            }
    end
  end
end

