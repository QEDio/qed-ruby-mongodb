# -*- encoding: utf-8 -*-
require 'spec_helper'

describe Qed::Mongodb::StatisticViewConfig do
  include Qed::Mongodb::Test::Fixtures::StatisticViewConfigStore

  context "Creating a StatisticViewConfig" do
    let(:fm) do
      fm = Qstate::FilterModel.new(Qed::Mongodb::Test::Factory::ScaleOfUniverse::PARAMS_SCALE_OF_UNIVERSE)
      fm.confidential.user = :test
      fm
    end

    it "raises an exception if param filter_model is nil" do
      expect {Qed::Mongodb::StatisticViewConfig.create_config(nil, nil)}.should
        raise_exception Qed::Mongodb::Exceptions::FilterModelError
    end

    it "raises an exception if filter_model is not a filter_model object" do
      expect {Qed::Mongodb::StatisticViewConfig.create_config([], nil)}.should
        raise_exception Qed::Mongodb::Exceptions::FilterModelError
    end

    it "raises an exception if param mapreduce_config is nil" do
      expect {Qed::Mongodb::StatisticViewConfig.create_config(fm, nil)}.should
        raise_exception Qed::Mongodb::Exceptions::FilterModelError
    end

    it "raises an exception if param mapreduce_config is not a hash" do
      expect {Qed::Mongodb::StatisticViewConfig.create_config(fm, [])}.should
        raise_exception Qed::Mongodb::Exceptions::FilterModelError
    end

    it "returns a valid view config object" do
      Qed::Mongodb::StatisticViewConfig.create_config(fm, MAPREDUCE_CONFIG)
    end
  end

  context "by providing a filtermodel with external emit keys" do
    FILTERMODEL_URI_1 = {
      'v_view'                        => 'something else',
      'v_action'                      => 'scale_of_universe',
      'v_controller'                  => 'dashboard',
      't_step_size'                   => 7,
      't_from'                        => '2011-06-05 22:00:00 UTC',
      't_till'                        => '2011-12-09 22:00:00 UTC',
      'q_product_name'                => 'Elektromobil',
      'm_key_that_needs_to_be_set'    => -1
    }

    let(:fm) do
      fm = Qstate::FilterModel.new(FILTERMODEL_URI_1)
      fm.confidential.user = :test
      fm
    end

    it "will delete the default emit_keys and set the provided ones" do
      mrms = Qed::Mongodb::StatisticViewConfig.create_config(fm, MAPREDUCE_CONFIG)

      mrms.size.should == 1

      mrm = mrms.first
      map = mrm.map

      map.keys.size.should == 1
      key = map.keys.first
      key.name.should == 'key_that_needs_to_be_set'
    end
    
  end
end