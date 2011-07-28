require File.dirname(__FILE__) + '/test_helper.rb'

class TestStatisticViewConfig < Test::Unit::TestCase
  should "should return view config" do
    fm = FilterModel.new(PARAMS)
    fm.user = USER

    Qed::Mongodb::StatisticViewConfig.create_config(fm)
  end
end
