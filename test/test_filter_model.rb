require File.dirname(__FILE__) + '/helper.rb'

class TestFilterModel < Test::Unit::TestCase
  should "should create filter model from params" do
    fm = FilterModel.new(PARAMS)

    # this test will fail until we handle mongo variables and filter variables in a consistent manner
    # maybe they are even the same, and the distinction is superflous
    assert_equal fm.mongodb["product_name"][:value], M_S_PRODUCT_NAME
  end

  should "create mongodb query" do
    fm = FilterModel.new(PARAMS)

    # if you know a better way, please come forward!
    assert_equal fm.mongodb_query.to_s, PARAMS_RESULTING_MONGODB_QUERY
  end
end


