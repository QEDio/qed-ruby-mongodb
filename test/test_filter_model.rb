require File.dirname(__FILE__) + '/test_helper.rb'

class TestFilterModel < Test::Unit::TestCase
  context "creating a filtermodel from a rails params hash" do
    setup do
      @fm = Qed::Filter::FilterModel.new(PARAMS_MR4)
    end

    should "should set the correct params values in the filtermodel" do
      assert_equal ACTION_NAME_MR2_VALUE, @fm.view
      assert_equal M_S_PRODUCT_NAME_VALUE, @fm.filter[:product_name][:value]
      assert_equal 1, @fm.map_reduce_params.emit_keys.size
    end

    should "create mongodb query" do
      # if you know a better way, please come forward!
      assert_equal PARAMS_RESULTING_MONGODB_QUERY, @fm.mongodb_query.to_s
    end

    should "convert to json and back again" do
      json = @fm.to_json
      new_fm = Qed::Filter::FilterModel.new(json)

      assert_equal @fm, new_fm
    end

    should "generate a correct URL with the provided params (next drilldown_level)" do
      row = URL_ROW
      key = URL_KEY
      field = URL_FIELD

      # TODO: this should pass but doesn't
      # TODO: why? because one parameter gets added twice to the url output, and this is wrong ;)
      assert_equal FM_GENERATED_PARAMS_URL_WITH_ADDITIONAL_PARAMETERS, @fm.url(row, key, field)
    end

    should "generate a correct URL with the provided params (next drilldown_level) despite having to clone a symbol" do
      @fm.user = USER
      row = URL_ROW
      key = URL_KEY
      field = URL_FIELD

      # TODO: this should pass but doesn't
      # TODO: why? because one parameter gets added twice to the url output, and this is wrong ;)
      assert_equal FM_GENERATED_PARAMS_URL_WITH_ADDITIONAL_PARAMETERS, @fm.url(row, key, field)
    end

    should "generate a correct URL for itself (same drilldown_level)" do
      assert_equal FM_GENERATED_PARAMS_URL, @fm.url
    end

    should "generate a correct URL using the provided row parameter" do
      row = URL_ROW
      assert_equal FM_GENERATD_PARAMS_WITH_ROW_URL, @fm.url(row)
    end



    should "create the correct digest for its current state" do
      assert_equal PARAMS_MR2_SHA2_DIGEST, @fm.digest
    end

    should "create a valid cloned filtermodel" do
      assert_equal PARAMS_MR2_SHA2_DIGEST, @fm.clone.digest
    end

    should "create a different digest for a different state" do
      fm_cloned = @fm.clone
      fm_cloned.view = "something else"
      assert_equal PARAMS_MR3_SHA2_DIGEST, fm_cloned.digest
    end
  end

  context "creating a filtermodel from a rails params with special characters" do
    setup do
      @fm = Qed::Filter::FilterModel.new(PARAMS_SPECIAL_CHARACTERS)
    end

    should "escape the special characters in the url" do
      assert_equal FM_GENERATED_PARAMS_URL_SPECIAL_CHARACTERS, @fm.url
    end
  end

  context "params with prefix 'm_k_'" do
    setup do
      @fm = Qed::Filter::FilterModel.new(PARAMS_MR4)
    end

    should "be stored in a MapReduceParams-Object" do
      assert_equal Qed::Filter::MapReduceParams, @fm.map_reduce_params.class
      assert_equal 1, @fm.map_reduce_params.emit_keys.size
      assert_equal PRODUCT_NAME_K, @fm.map_reduce_params.emit_keys.first.key
      assert_equal M_K_PRODUCT_NAME_VALUE, @fm.map_reduce_params.emit_keys.first.value
    end

  end
end


