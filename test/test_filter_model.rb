require File.dirname(__FILE__) + '/helper.rb'

class TestFilterModel < Test::Unit::TestCase
  should "should create filter model from params" do
    fm = FilterModel.new(PARAMS)

    assert_equal ACTION_NAME, fm.action_name
    assert_equal M_S_PRODUCT_NAME, fm.filter[:product_name][:value]
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

  should "generate a correct URL" do
    fm = FilterModel.new(PARAMS)
    row = URL_ROW
    key = URL_KEY
    field = URL_FIELD

    fm.url(row, key, field)
  end
end


