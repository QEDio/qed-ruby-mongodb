# -*- encoding: utf-8 -*-
require 'spec_helper'

describe Qed::Mongodb::MapReduce::Performer do
  include Qed::Mongodb::Test::Fixtures::StatisticViewConfigStore

  context "a performer" do
    it "loads" do
      Qed::Mongodb::MapReduce::Performer
    end
  end

  context "calling function mapreduce" do
    it "raises an exception if option is not a hash" do
      expect {Qed::Mongodb::MapReduce::Performer.new([], :config => MAPREDUCE_CONFIG)}.
        should raise_exception Qed::Mongodb::Exceptions::OptionMisformed

    end

    it "raises an exception if the 'filter' value is not a FilterModel-Object" do
      expect{ Qed::Mongodb::MapReduce::Performer.new({:filter => "fm"}, :config => MAPREDUCE_CONFIG) }.
        should raise_exception Qed::Mongodb::Exceptions::OptionMisformed
    end
  end

  context "performing mapreduce in the Universe" do
    before(:each) do
      Mongodb::Testdata::Factory::ScaleOfUniverse.big_crunch
      Mongodb::Testdata::Factory::ScaleOfUniverse.
        big_bang(Mongodb::Testdata::Factory::ScaleOfUniverse::EXAMPLE_UNIVERSE)
    end

    context "to create a drilldown statistic five steps below the top view" do
      let(:fm) do
        fm = Qstate::FilterModel.new(Mongodb::Testdata::Factory::ScaleOfUniverse::PARAMS_SCALE_OF_UNIVERSE)
        fm.confidential.user = :test
        fm
      end

      let(:performer){ Qed::Mongodb::MapReduce::Performer.new(fm, :config => MAPREDUCE_CONFIG, :cache => false) }

      it "works flawlessly" do
        data = performer.mapreduce[:result].find().to_a

        # filter nil elements, for now
        # TODO: can we do something about objects that are not within this map-reduce scope?
        # TODO: this will be kinda important with subsequent mapreduce requests, where those
        # TODO: might yield some new information (since the fall into a mapreduced scope again)
        raise Exception.new("This will only work with one emit key") if data.first["_id"].size > 1
        data = data.select{ |d| !d["_id"].values.first.nil? }

        data.size.should == Mongodb::Testdata::Factory::ScaleOfUniverse.
                              line_items_with_same_value_in_dimension(data.first["_id"])

        data.each do |mr_result|
          mr_result["value"]["count"].should == Mongodb::Testdata::Factory::ScaleOfUniverse.
                                                  amount_of_objects_in_universe(mr_result["_id"])
        end
      end
    end
  end

  context "performing mapreduce on a WorldWideBusiness" do
    before(:each) do
      Mongodb::Testdata::Factory::WorldWideBusiness.sell_out
      Mongodb::Testdata::Factory::WorldWideBusiness.
        startup(Mongodb::Testdata::Factory::WorldWideBusiness::WORLD_WIDE_BUSINESS)
    end

    let(:fm) do
      fm                    = Qstate::FilterModel.new(Mongodb::Testdata::Factory::WorldWideBusiness::PARAMS_WORLD_WIDE_BUSINESS)
      fm.view.view          = Mongodb::Testdata::Factory::WorldWideBusiness::VIEW_LOC_DIM0
      fm.confidential.user  = :test
      fm
    end

    let(:performer) { Qed::Mongodb::MapReduce::Performer.new(fm, :config => MAPREDUCE_CONFIG) }

    it "use the cache for the second mapreduce query" do
      data = performer.mapreduce
      data[:cached].should be_false

      data = performer.mapreduce
      data[:cached].should be_true
    end

    context "on the Dimension location" do
      context "to create a the top view statistic" do
        before(:each) do
          fm.view.view = Mongodb::Testdata::Factory::WorldWideBusiness::VIEW_LOC_DIM0
        end

        let(:performer) { performer = Qed::Mongodb::MapReduce::Performer.new(fm, :config => MAPREDUCE_CONFIG, :cache => false) }
        let(:data)      { performer.mapreduce[:result].find().to_a }
        let(:mr_key)    { spec_helper_get_mr_key(performer).join(",") }

        it "returns the correct number of mapreduced datarows" do
          Mongodb::Testdata::Factory::WorldWideBusiness.
            different_values_for_mr[mr_key].size.should == data.size
        end

        it "returns the correct amount of same data values" do
          data.each do |mr_result|
            mr_result["value"]["count"].to_i.should ==
                Mongodb::Testdata::Factory::WorldWideBusiness.
                line_items_with_same_value_in_dimension(data.first["_id"], :location)
          end
        end
      end

      context "to create a drilldown statistic one level below the top view" do
        before(:each) do
          fm.view.view = Mongodb::Testdata::Factory::WorldWideBusiness::VIEW_LOC_DIM1
        end

        let(:performer) { performer = Qed::Mongodb::MapReduce::Performer.new(fm, :config => MAPREDUCE_CONFIG, :cache => false) }
        let(:data)      { performer.mapreduce[:result].find().to_a }
        let(:mr_key)    { spec_helper_get_mr_key(performer).join(",") }

        it "returns the correct number of mapreduced datarows" do
          data.size.should ==
              Mongodb::Testdata::Factory::WorldWideBusiness.different_values_for_mr[mr_key].size
        end

        it "returns the correct amount of same data values" do
          data.each do |mr_result|
            mr_result["value"]["count"].to_i.should ==
                Mongodb::Testdata::Factory::WorldWideBusiness.
                line_items_with_same_value_in_dimension(mr_result["_id"], :location)
          end
        end
      end

      context "to create a drilldown statistic two level below the top view" do
        before(:each) do
          fm.view.view = Mongodb::Testdata::Factory::WorldWideBusiness::VIEW_LOC_DIM2
        end

        let(:performer) { performer = Qed::Mongodb::MapReduce::Performer.new(fm, :config => MAPREDUCE_CONFIG, :cache => false) }
        let(:data)      { performer.mapreduce[:result].find().to_a }
        let(:mr_key)    { spec_helper_get_mr_key(performer).join(",") }

        it "returns the correct number of mapreduced datarows" do
          data.size.should ==
              Mongodb::Testdata::Factory::WorldWideBusiness.different_values_for_mr[mr_key].size
        end

        it "returns the correct amount of same data values" do
          data.each do |mr_result|
            mr_result["value"]["count"].to_i.should ==
                Mongodb::Testdata::Factory::WorldWideBusiness.
                line_items_with_same_value_in_dimension(mr_result["_id"], :location)
          end
        end
      end

      context "to create a drilldown statistic three level below the top view" do
        before(:each) do
          fm.view.view = Mongodb::Testdata::Factory::WorldWideBusiness::VIEW_LOC_DIM3
        end

        let(:performer) { performer = Qed::Mongodb::MapReduce::Performer.new(fm, :config => MAPREDUCE_CONFIG, :cache => false) }
        let(:data)      { performer.mapreduce[:result].find().to_a }
        let(:mr_key)    { spec_helper_get_mr_key(performer).join(",") }

        it "returns the correct number of mapreduced datarows" do
          data.size.should ==
              Mongodb::Testdata::Factory::WorldWideBusiness.different_values_for_mr[mr_key].size
        end

        it "return the correct amount of same data values" do
          data.each do |mr_result|
            mr_result["value"]["count"].to_i.should ==
                Mongodb::Testdata::Factory::WorldWideBusiness.
                line_items_with_same_value_in_dimension(mr_result["_id"], :location)
          end
        end
      end
    end

    context "performing a query on a WorldWideBusiness" do
      before(:each) do
        Mongodb::Testdata::Factory::WorldWideBusiness.sell_out
        Mongodb::Testdata::Factory::WorldWideBusiness.
          startup(Mongodb::Testdata::Factory::WorldWideBusiness::WORLD_WIDE_BUSINESS)
      end

      let(:fm) do
        fm = Qstate::FilterModel.new(Mongodb::Testdata::Factory::WorldWideBusiness::PARAMS_WORLD_WIDE_BUSINESS)
        fm.confidential.user = :test
        fm
      end

      context "on the Dimension location" do
        context "to create a filter but unreduced view on the data" do
          context "on DIM0" do
            before(:each) do
              fm.view.view = Mongodb::Testdata::Factory::WorldWideBusiness::VIEW_LOC_DIM0
            end

            let(:performer) { Qed::Mongodb::MapReduce::Performer.new(fm, :config => MAPREDUCE_CONFIG, :cache => false) }
              # TODO: we are not using mrapper here, so this is going to be bad
            let(:data)      { performer.mapreduce[:result].find().to_a }
            let(:mr_key)    { performer.get_mr_key.join(",") }

            # TODO: we need something to test the filtering/query thingy
            # TODO: below this is a workaround
            it "returns the correct number of filtered datarows" do
              data.first["value"]["count"].should ==
                  Mongodb::Testdata::Factory::WorldWideBusiness.
                  line_items_with_same_value_in_dimension(data.first["value"]["DIM_LOC_0"], :location)
            end
          end
        end
      end
    end
  end
end