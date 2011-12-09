require 'spec_helper'

describe Qed::Mongodb::QueryBuilder do
  include Qed::Mongodb::Test::Fixtures::QueryBuilder
  include Qed::Mongodb::Test::Fixtures::StatisticViewConfigStore

  context "a builder" do
    let(:fm) do
      fm = Qstate::FilterModel.new(Qed::Mongodb::Test::Fixtures::Factory::ScaleOfUniverse::PARAMS_SCALE_OF_UNIVERSE)
      fm.view.view = :query_only_scale_of_universe
      fm.confidential.user = USER
      fm
    end

    let(:mr_config) { MAPREDUCE_CONFIG }

    context "with no query" do
      it "returns nil" do
        mapreduce_model = Qed::Mongodb::StatisticViewConfig.create_config(fm, mr_config)
        mapreduce_model.size.should == 1
        mapreduce_model.first.query.present?.should be_false
      end
    end
  end

  context "with two timepoints" do
    let(:fm) do
      fm = Qstate::FilterModel.new(QB_PARAMS_1)
      fm.view.view = :query_only_scale_of_universe
      fm.confidential.user = USER
      fm
    end

    it "does return teh correct query" do
      Qed::Mongodb::QueryBuilder.
        selector(fm, :clasz => Qed::Mongodb::MongoidModel, :time_params => ["date_field1", "date_field2"]).to_s.
        should == QB_QUERY1
    end
  end
end