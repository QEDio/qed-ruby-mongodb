MAPREDUCE1 =
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
                :map                  => MAP1,
                :reduce               => REDUCE1,
                :finalize             => FINALIZE1
            }

MAPREDUCE2 =
            {
                :key => {:name => "product_name",     :function => "value.product_name"},
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
                :map        => MAP2,
                :reduce     => REDUCE2,
                :finalize   => FINALIZE2
            }