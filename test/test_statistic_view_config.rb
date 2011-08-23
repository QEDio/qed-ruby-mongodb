require File.dirname(__FILE__) + '/test_helper.rb'

class TestStatisticViewConfig < Test::Unit::TestCase
  context "Creating a StatisticViewConfig" do
    setup do
      @fm =  Qed::Filter::FilterModel.new(Qed::Mongodb::Test::Factory::ScaleOfUniverse::PARAMS_SCALE_OF_UNIVERSE)
      @fm.user = USER
    end

    should "raise an exception if param filter_model is nil" do
      assert_raise Qed::Mongodb::Exceptions::FilterModelError do
        Qed::Mongodb::StatisticViewConfig.create_config(nil, nil)
      end
    end

    should "raise an exception if param filter_model is not a filter_model" do
      assert_raise Qed::Mongodb::Exceptions::FilterModelError do
        Qed::Mongodb::StatisticViewConfig.create_config([], nil)
      end
    end

    should "raise an exception if param mapreduce_config is nil" do
      assert_raise Qed::Mongodb::Exceptions::FilterModelError do
        Qed::Mongodb::StatisticViewConfig.create_config(@fm, nil)
      end
    end

    should "raise an exception if param mapreduce_config is not a hash" do
      assert_raise Qed::Mongodb::Exceptions::FilterModelError do
        Qed::Mongodb::StatisticViewConfig.create_config(@fm, [])
      end
    end

    should "should return a valid view config" do
      Qed::Mongodb::StatisticViewConfig.create_config(@fm, MAPREDUCE_CONFIG)
    end
  end
end
