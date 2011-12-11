require 'spec_helper'

describe Qed::Mongodb::QueryBuilder do
  include Qed::Mongodb::Test::Fixtures::StatisticViewConfigStore

  context "a builder" do
    let(:fm) do
      fm = Qstate::FilterModel.new(Qed::Mongodb::Test::Factory::ScaleOfUniverse::PARAMS_SCALE_OF_UNIVERSE)
      fm.view.view = :query_only_scale_of_universe
      fm.confidential.user = :test
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
    QUERY_BUILDER_FILTERMODEL_URI_1 = {
      'v_view'                        => 'something else',
      'v_action'                      => 'scale_of_universe',
      'v_controller'                  => 'dashboard',
      't_step_size'                   => 7,
      't_from'                        => '2011-06-05 22:00:00 UTC',
      't_till'                        => '2011-12-09 22:00:00 UTC',
      'q_product_name'                => 'Elektromobil'
    }

    QB_QUERY1 = '{:"value.date_field1"=>{"$gte"=>2011-06-05 22:00:00 UTC, "$lt"=>2011-12-09 22:00:00 UTC},'+
                ' :"value.date_field2"=>{"$gte"=>2011-06-05 22:00:00 UTC, "$lt"=>2011-12-09 22:00:00 UTC},'+
                ' "value.product_name"=>"Elektromobil"}'


    let(:fm) do
      fm = Qstate::FilterModel.new(QUERY_BUILDER_FILTERMODEL_URI_1)
      fm.view.view = :query_only_scale_of_universe
      fm.confidential.user = :test
      fm
    end

    it "does return teh correct query" do
      Qed::Mongodb::QueryBuilder.
        selector(fm, :clasz => Qed::Mongodb::MongoidModel, :time_params => ["date_field1", "date_field2"]).to_s.
          should == QB_QUERY1
    end
  end
end