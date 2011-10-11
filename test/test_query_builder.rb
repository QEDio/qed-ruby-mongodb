require File.dirname(__FILE__) + '/test_helper.rb'

class TestQueryBuilder < Test::Unit::TestCase
  include Qed::Test::QueryBuilder
  
  context "a builder" do
    include Qed::Test::StatisticViewConfigStore
    
    setup do
      @fm = Qaram::FilterModel.new(Qed::Test::Mongodb::Factory::ScaleOfUniverse::PARAMS_SCALE_OF_UNIVERSE)
      @fm.view.view = :query_only_scale_of_universe
      @fm.confidential.user = USER
      @mr_config = MAPREDUCE_CONFIG
    end

    context "with no query" do
      should "return nil" do
        mapreduce_model = Qed::Mongodb::StatisticViewConfig.create_config(@fm, @mr_config)
        assert_equal 1, mapreduce_model.size
        assert_equal nil, mapreduce_model.first.query
      end
    end
  end

  context "for two timepoints" do
    setup do
      @fm = Qaram::FilterModel.new(QB_PARAMS_1)
      @fm.view.view = :query_only_scale_of_universe
      @fm.confidential.user = USER
    end

    should "return correctly" do
      assert_equal QB_QUERY1, Qed::Mongodb::QueryBuilder.selector(@fm, :clasz => Qed::Mongodb::MongoidModel, :time_params => ["date_field1", "date_field2"]).to_s
    end
  end
end
