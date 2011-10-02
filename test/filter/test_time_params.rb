require File.dirname(__FILE__) + '/../test_helper.rb'

class TestTimeParams < Test::Unit::TestCase
  context "creating a TimeParams object" do
    setup do
      @time_params      = Qed::RESTX::TimeParams.new("2011-01-01", "2011-01-02", :step_size => 1)
    end

    should "return the correct from value" do
      assert_equal Time.parse("2011-01-01").utc, @time_params.from
    end

    should "return the correct step size" do
      assert_equal 1, @time_params.step_size
    end
  end
end