require File.dirname(__FILE__) + '/helper.rb'

class TestFilterModel < Test::Unit::TestCase
  should "should create filter model from params" do
    fm = FilterModel.new(PARAMS)

    assert_equal ACTION_NAME_VALUE, fm.view
    assert_equal M_S_PRODUCT_NAME_VALUE, fm.filter[:product_name][:value]
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

  should "generate a correct URL with the provided params" do
    fm = FilterModel.new(PARAMS)
    row = URL_ROW
    key = URL_KEY
    field = URL_FIELD

    assert_equal FM_GENERATED_PARAMS_URL_WITH_ADDITIONAL_PARAMETERS, fm.url(row, key, field)
  end

  should "generate a correct URL for itself" do
    fm = FilterModel.new(PARAMS)
    assert_equal FM_GENERATED_PARAMS_URL, fm.url
  end

  should "symbolize hash keys" do
    hsh1 = {"a" => "b"}
    hsh2 = {:a => "b"}

    assert_equal FilterModel.symbolize_keys(hsh1), hsh2
  end


end


