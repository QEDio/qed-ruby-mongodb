# -*- encoding: utf-8 -*-
module Qed
  module Mongodb
    class StatisticViewConfigStore
      PROFILE = {
        #:kp => {
        #  :early_warning => {
        #    :mapreduce => [
        #      Qed::Mongodb::MapReduce::Config::KP_EW_1
        #    ]
        #  },
        #
        #  :adwords_db => {
        #    :mapreduce => [
        #      Qed::Mongodb::MapReduce::Config::KP_ADWORDS_DB_1,
        #      Qed::Mongodb::MapReduce::Config::KP_ADWORDS_DB_2,
        #      Qed::Mongodb::MapReduce::Config::KP_ADWORDS_DB_3,
        #      Qed::Mongodb::MapReduce::Config::KP_ADWORDS_DB_4,
        #    ]
        #  },
        #
        #  :optimize => {
        #    :mapreduce => [
        #      Qed::Mongodb::MapReduce::Config::KP_OPTIMIZE_1,
        #      Qed::Mongodb::MapReduce::Config::KP_OPTIMIZE_2,
        #      Qed::Mongodb::MapReduce::Config::KP_OPTIMIZE_3,
        #      Qed::Mongodb::MapReduce::Config::KP_OPTIMIZE_4
        #    ]
        #  },
        #
        #  :optimize_seo => {
        #    :mapreduce => [
        #      Qed::Mongodb::MapReduce::Config::KP_OPTIMIZE_SEO_1,
        #      Qed::Mongodb::MapReduce::Config::KP_OPTIMIZE_SEO_2
        #    ]
        #  },
        #
        #  cr2_comparision: {
        #    mapreduce: [
        #      Qed::Mongodb::MapReduce::Config::KP_PRODUKTANFRAGEN,
        #      Qed::Mongodb::MapReduce::Config::KP_CR2_COMPARISON_1
        #    ]
        #  },
        #
        #  :conversion_by_channel => {
        #    # the order is important here, the first mapreduce will be done first, then the second and so on
        #    :mapreduce => [
        #      Qed::Mongodb::MapReduce::Config::KP_CBP_1,
        #      Qed::Mongodb::MapReduce::Config::KP_CBC_2
        #    ]
        #  },

          #:conversion_by_product => {
          #  :mapreduce => [
          #    Qed::Mongodb::MapReduce::Config::KP_CBP_1,
          #    Qed::Mongodb::MapReduce::Config::KP_CBP_2
          #  ]
          #},
          #
          #:topseller => {
          #  :mapreduce => [
          #    Qed::Mongodb::MapReduce::Config::KP_CBP_1,
          #    Qed::Mongodb::MapReduce::Config::KP_CBP_2
          #  ]
          #},
          #
          #:tracking => {
          #  :mapreduce => [
          #    Qed::Mongodb::MapReduce::Config::KP_CBP_1,
          #    Qed::Mongodb::MapReduce::Config::KP_TRA_2
          #  ]
          #}
        #},

        :vidibus => {
          :vidibus_test => {
            :mapreduce => [
              Qed::Mongodb::MapReduce::Config::VIDIBUS_VIDEO_HISTOGRAM
            ]
          },
          :server_traffic =>{
            :mapreduce => [
                Qed::Mongodb::MapReduce::Config::VIDIBUS_SERVER_TRAFFIC
            ]
          },
          :server_views =>{
            :mapreduce => [
              Qed::Mongodb::MapReduce::Config::VIDIBUS_SERVER_ASSET_VIEWS_1,
              Qed::Mongodb::MapReduce::Config::VIDIBUS_SERVER_ASSET_VIEWS_2,
            ]
          },
          :server_storage => {
            :mapreduce => [
              Qed::Mongodb::MapReduce::Config::VIDIBUS_SERVER_STORAGE_1,
              Qed::Mongodb::MapReduce::Config::VIDIBUS_SERVER_STORAGE_2
            ]
          }
        }
      }
    end
  end
end
