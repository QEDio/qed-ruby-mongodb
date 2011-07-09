require File.dirname(__FILE__) + '/helper.rb'

class TestFilterModel < Test::Unit::TestCase
  should "should create filter model from params" do
    fm = FilterModel.new(PARAMS)

    assert_equal fm.filter[:product_name][:value], M_S_PRODUCT_NAME
  end

  should "create mongodb query" do
    fm = FilterModel.new(PARAMS)

    # if you know a better way, please come forward!
    assert_equal PARAMS_RESULTING_MONGODB_QUERY, fm.mongodb_query.to_s
  end

  should "convert to json and back again" do
    fm = FilterModel.new(PARAMS)
    json = fm.to_json
    new_fm = FilterModel.new(json)

    assert_equal fm, new_fm
  end
end


