require File.dirname(__FILE__) + '/helper.rb'

class TestStatisticViewConfig < Test::Unit::TestCase
  should "should return view config" do
    fm = FilterModel.new(PARAMS)
    fm.user = USER
    level = 0

    Qed::Mongodb::StatisticViewConfig.create_config(fm, level)
  end
end
