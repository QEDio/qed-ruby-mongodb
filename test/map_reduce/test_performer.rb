require File.dirname(__FILE__) + '/../test_helper.rb'

class TestMapReducePerformer < Test::Unit::TestCase
  include Qed::Test::StatisticViewConfigStore
  
  should "load" do
    Qed::Mongodb::MapReduce::Performer
  end

  context "calling function mapreduce" do
    should "throw an exception if option is not a hash" do
      assert_raise Qed::Mongodb::Exceptions::OptionMisformed do
        Qed::Mongodb::MapReduce::Performer.new([], MAPREDUCE_CONFIG)
      end
    end

    should "throw an exception if the 'filter' value is not a FilterModel-Object" do
      assert_raise Qed::Mongodb::Exceptions::OptionMisformed do
        Qed::Mongodb::MapReduce::Performer.new({:filter => "fm"}, MAPREDUCE_CONFIG)
      end
    end

    context "performing mapreduce in the Universe" do
      setup do
        Qed::Test::Mongodb::Factory::ScaleOfUniverse.big_crunch
        Qed::Test::Mongodb::Factory::ScaleOfUniverse.big_bang(Qed::Test::Mongodb::Factory::ScaleOfUniverse::EXAMPLE_UNIVERSE)
        @fm = Qaram::FilterModel.new(Qed::Test::Mongodb::Factory::ScaleOfUniverse::PARAMS_SCALE_OF_UNIVERSE)
        @fm.confidential.user = USER
      end

      context "to create a drilldown statistic five steps below the top view" do
        should "work" do
          performer = Qed::Mongodb::MapReduce::Performer.new(@fm, MAPREDUCE_CONFIG)
          data = performer.mapreduce[:result].find().to_a

          # filter nil elements, for now
          # TODO: can we do something about objects that are not within this map-reduce scope?
          # TODO: this will be kinda important with subsequent mapreduce requests, where those
          # TODO: might yield some new information (since the fall into a mapreduced scope again)
          raise Exception.new("This will only work with one emit key") if data.first["_id"].size > 1
          data = data.select{ |d| !d["_id"].values.first.nil? }

          assert_equal  Qed::Test::Mongodb::Factory::ScaleOfUniverse.line_items_with_same_value_in_dimension(data.first["_id"]), data.size

          data.each do |mr_result|
            assert_equal  Qed::Test::Mongodb::Factory::ScaleOfUniverse.amount_of_objects_in_universe(mr_result["_id"]), mr_result["value"]["count"]
          end
        end
      end
    end

    context "performing mapreduce on a WorldWideBusiness" do
      setup do
        Qed::Test::Mongodb::Factory::WorldWideBusiness.sell_out
        Qed::Test::Mongodb::Factory::WorldWideBusiness.startup(Qed::Test::Mongodb::Factory::WorldWideBusiness::WORLD_WIDE_BUSINESS)
        @fm = Qaram::FilterModel.new(Qed::Test::Mongodb::Factory::WorldWideBusiness::PARAMS_WORLD_WIDE_BUSINESS)
        @fm.confidential.user = USER
      end

      should "use the cache for the second mapreduce query" do
        @fm.view.view = Qed::Test::Mongodb::Factory::WorldWideBusiness::VIEW_LOC_DIM0
        @performer = Qed::Mongodb::MapReduce::Performer.new(@fm, MAPREDUCE_CONFIG)
        @data = @performer.mapreduce

        assert_equal false, @data[:cached]

        @data = @performer.mapreduce

        assert_equal true, @data[:cached]
      end

      context "on the Dimension location" do
        setup do
        end

        context "to create a the top view statistic" do
          setup do
            @fm.view.view = Qed::Test::Mongodb::Factory::WorldWideBusiness::VIEW_LOC_DIM0
            @performer = Qed::Mongodb::MapReduce::Performer.new(@fm, MAPREDUCE_CONFIG)
            @data = @performer.mapreduce[:result].find().to_a
            @mr_key = @performer.get_mr_key.join(",")
          end

          should "return the correct number of mapreduced datarows" do
            assert_equal Qed::Test::Mongodb::Factory::WorldWideBusiness.different_values_for_mr[@mr_key].size, @data.size
          end

          should "return the correct amount of same data values" do
            @data.each do |mr_result|
              assert_equal Qed::Test::Mongodb::Factory::WorldWideBusiness.
                line_items_with_same_value_in_dimension(@data.first["_id"], :location), mr_result["value"]["count"].to_i
            end
          end
        end

        context "to create a drilldown statistic one level below the top view" do
          setup do
            @fm.view.view = Qed::Test::Mongodb::Factory::WorldWideBusiness::VIEW_LOC_DIM1
            @performer = Qed::Mongodb::MapReduce::Performer.new(@fm, MAPREDUCE_CONFIG)
            @data = @performer.mapreduce[:result].find().to_a
            @mr_key = @performer.get_mr_key.join(",")
          end

          should "return the correct number of mapreduced datarows" do
            assert_equal Qed::Test::Mongodb::Factory::WorldWideBusiness.different_values_for_mr[@mr_key].size, @data.size
          end

          should "return the correct amount of same data values" do
            @data.each do |mr_result|
              assert_equal Qed::Test::Mongodb::Factory::WorldWideBusiness.line_items_with_same_value_in_dimension(mr_result["_id"], :location), mr_result["value"]["count"].to_i
            end
          end
        end

        context "to create a drilldown statistic two level below the top view" do
          setup do
            @fm.view.view = Qed::Test::Mongodb::Factory::WorldWideBusiness::VIEW_LOC_DIM2
            @performer = Qed::Mongodb::MapReduce::Performer.new(@fm, MAPREDUCE_CONFIG)
            @data = @performer.mapreduce[:result].find().to_a
            @mr_key = @performer.get_mr_key.join(",")
          end

          should "return the correct number of mapreduced datarows" do
            assert_equal Qed::Test::Mongodb::Factory::WorldWideBusiness.different_values_for_mr[@mr_key].size, @data.size
          end

          should "return the correct amount of same data values" do
            @data.each do |mr_result|
              assert_equal Qed::Test::Mongodb::Factory::WorldWideBusiness.line_items_with_same_value_in_dimension(mr_result["_id"], :location), mr_result["value"]["count"].to_i
            end
          end
        end

        context "to create a drilldown statistic three level below the top view" do
          setup do
            @fm.view.view = Qed::Test::Mongodb::Factory::WorldWideBusiness::VIEW_LOC_DIM3
            @performer = Qed::Mongodb::MapReduce::Performer.new(@fm, MAPREDUCE_CONFIG)
            @data = @performer.mapreduce[:result].find().to_a
            @mr_key = @performer.get_mr_key.join(",")
          end

          should "return the correct number of mapreduced datarows" do
            assert_equal Qed::Test::Mongodb::Factory::WorldWideBusiness.different_values_for_mr[@mr_key].size, @data.size
          end

          should "return the correct amount of same data values" do
            @data.each do |mr_result|
              assert_equal Qed::Test::Mongodb::Factory::WorldWideBusiness.line_items_with_same_value_in_dimension(mr_result["_id"], :location), mr_result["value"]["count"].to_i
            end
          end
        end
      end
    end
    
    context "with at least two map emit keys" do
      setup do
        Qed::Test::Mongodb::Factory::WorldWideBusiness.sell_out
        Qed::Test::Mongodb::Factory::WorldWideBusiness.startup(Qed::Test::Mongodb::Factory::WorldWideBusiness::WORLD_WIDE_BUSINESS)

        @fm = Qaram::FilterModel.new(Qed::Test::Mongodb::Factory::WorldWideBusiness::PARAMS_WORLD_WIDE_BUSINESS_WITH_MAP_EMIT_KEYS)
        @fm.confidential.user = USER
        @fm.view.view = Qed::Test::Mongodb::Factory::WorldWideBusiness::VIEW_LOC_DIM3
        @performer = Qed::Mongodb::MapReduce::Performer.new(@fm, MAPREDUCE_CONFIG)
      end

      should "TODO: write test-framework to check returned mapreduce data" do
        @data = @performer.mapreduce[:result].find().to_a
        #puts @data.inspect
        raise Exception.new("After the refactoring, this is definitely wrong!")
        # TODO: Exception before factor
        #raise Exception.new("The returned data seems to be ok, checked against the Google Docs-Sheet. But we have to write the corresponding testfunctions in here.")
      end
    end

    context "performing a query on a WorldWideBusiness" do
      setup do
        Qed::Test::Mongodb::Factory::WorldWideBusiness.sell_out
        Qed::Test::Mongodb::Factory::WorldWideBusiness.startup(Qed::Test::Mongodb::Factory::WorldWideBusiness::WORLD_WIDE_BUSINESS)
        @fm = Qaram::FilterModel.new(Qed::Test::Mongodb::Factory::WorldWideBusiness::PARAMS_WORLD_WIDE_BUSINESS)
        @fm.confidential.user = USER
      end

      context "on the Dimension location" do
        setup do
        end

        context "to create a filter but unreduced view on the data" do
          context "on DIM0" do
            setup do
              @fm.view.view = Qed::Test::Mongodb::Factory::WorldWideBusiness::VIEW_LOC_DIM0
              @performer = Qed::Mongodb::MapReduce::Performer.new(@fm, MAPREDUCE_CONFIG)
              # TODO: we are not using mrapper here, so this is going to be bad
              @data = @performer.mapreduce[:result].find().to_a
              @mr_key = @performer.get_mr_key.join(",")
            end

            # TODO: we need something to test the filtering/query thingy
            # TODO: below this is a workaround
            should "return the correct number of filtered datarows" do
              assert_equal Qed::Test::Mongodb::Factory::WorldWideBusiness.line_items_with_same_value_in_dimension(@data.first["value"]["DIM_LOC_0"], :location), @data.first["value"]["count"]
            end
          end
        end
      end
    end
  end
end
