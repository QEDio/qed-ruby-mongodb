require 'spec_helper'

describe Qed::Mongodb::StatisticViewConfig do
  include Qed::Mongodb::Test::Fixtures::StatisticViewConfigStore

  context "Creating a StatisticViewConfig" do
    let(:fm) do
      fm = Qstate::FilterModel.new(Qed::Test::Mongodb::Factory::ScaleOfUniverse::PARAMS_SCALE_OF_UNIVERSE)
      fm.confidential.user = USER
    end

    it "raises an exception if param filter_model is nil" do
      #Qed::Mongodb::Exceptions::FilterModelError do
      expect {Qed::Mongodb::StatisticViewConfig.create_config(nil, nil)}.should raise_exception Qed::Mongodb::Exceptions::FilterModelError
      #end
    end
  end
end

#  context "Creating a StatisticViewConfig" do
#    setup do
#      @fm =  Qstate::FilterModel.new(Qed::Test::Mongodb::Factory::ScaleOfUniverse::PARAMS_SCALE_OF_UNIVERSE)
#      @fm.confidential.user = USER
#    end
#
#    should "raise an exception if param filter_model is nil" do
#      assert_raise Qed::Mongodb::Exceptions::FilterModelError do
#        Qed::Mongodb::StatisticViewConfig.create_config(nil, nil)
#      end
#    end
#
#    should "raise an exception if param filter_model is not a filter_model" do
#      assert_raise Qed::Mongodb::Exceptions::FilterModelError do
#        Qed::Mongodb::StatisticViewConfig.create_config([], nil)
#      end
#    end
#
#    should "raise an exception if param mapreduce_config is nil" do
#      assert_raise Qed::Mongodb::Exceptions::FilterModelError do
#        Qed::Mongodb::StatisticViewConfig.create_config(@fm, nil)
#      end
#    end
#
#    should "raise an exception if param mapreduce_config is not a hash" do
#      assert_raise Qed::Mongodb::Exceptions::FilterModelError do
#        Qed::Mongodb::StatisticViewConfig.create_config(@fm, [])
#      end
#    end
#
#    should "should return a valid view config" do
#      Qed::Mongodb::StatisticViewConfig.create_config(@fm, MAPREDUCE_CONFIG)
#    end
#  end
#
#  context "Using StatisticViewConfig to return MapReduceModel Objects" do
#    context "by providing a filtermodel with external emit keys" do
#      setup do
#        @fm = Qstate::FilterModel.new(QARAM_PARAMS_1)
#        @fm.confidential.user = USER
#      end
#
#      should "delete the default emit_keys and set the provided ones" do
#        mrms = Qed::Mongodb::StatisticViewConfig.create_config(@fm, MAPREDUCE_CONFIG)
#
#        assert_equal 1, mrms.size
#        mrm = mrms.first
#        map = mrm.map
#
#        assert_equal 1, map.keys.size
#        key = map.keys.first
#        assert_equal EMIT_KEY_PRODUCT, key.name
#      end
#    end
#  end
#end
