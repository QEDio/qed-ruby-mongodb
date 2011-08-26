require File.dirname(__FILE__) + '/test_helper.rb'

class TestQueryBuilder < Test::Unit::TestCase
  context "a builder" do
    setup do
      @fm = Qed::Filter::FilterModel.new(Qed::Mongodb::Test::Factory::ScaleOfUniverse::PARAMS_SCALE_OF_UNIVERSE)
      @fm.drilldown_level_current = 2
      @fm.view = :query_only_scale_of_universe
      @fm.user = USER
      @mr_config = MAPREDUCE_CONFIG
    end

    context "for queries only" do
      should "respond with true to query_only?" do
        mapreduce_model = Qed::Mongodb::StatisticViewConfig.create_config(@fm, @mr_config)

        assert_equal 1, mapreduce_model.size
        assert_equal true, mapreduce_model.first.query_only?
      end
    end

    context "with no query" do
      should "return nil" do
        mapreduce_model = Qed::Mongodb::StatisticViewConfig.create_config(@fm, @mr_config)
        assert_equal 1, mapreduce_model.size
        assert_equal nil, mapreduce_model.first.query
      end
    end
  end
end
