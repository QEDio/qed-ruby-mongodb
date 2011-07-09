require File.dirname(__FILE__) + '/helper.rb'

class TestStatisticViewConfig < Test::Unit::TestCase
  should "should return view config" do
    fm = FilterModel.new(PARAMS)
    action = PARAMS["action"].to_sym
    user = USER.to_sym
    level = 0

    Qed::Mongodb::StatisticViewConfig.create_config(user, action, fm, level)
  end
end
