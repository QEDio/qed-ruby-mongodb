require File.dirname(__FILE__) + '/../test_helper.rb'

class TestMapReducePerformer < Test::Unit::TestCase
  should "load" do
    Qed::Mongodb::MapReduce::Performer
  end

  context "calling function mapreduce" do
    should "throw an exception if option is not a hash" do
      assert_raise Qed::Mongodb::Exceptions::OptionMisformed do
        Qed::Mongodb::MapReduce::Performer.new([], MAPREDUCE_CONFIG)
      end
    end

    should "throw an exception if option doesn't have the 'filter' key" do
      fm = FilterModel.new(PARAMS_MR2)
      assert_raise Qed::Mongodb::Exceptions::OptionMisformed do
        Qed::Mongodb::MapReduce::Performer.new({:abc => fm}, MAPREDUCE_CONFIG)
      end
    end

    should "throw an exception if the 'filter' value is not a FilterModel-Object" do
      assert_raise Qed::Mongodb::Exceptions::OptionMisformed do
        Qed::Mongodb::MapReduce::Performer.new({:filter => "fm"}, MAPREDUCE_CONFIG)
      end
    end

    #should "return one mapreduced result for a drilldown level of 0 and a filter for Elektromobil" do
    #  fm = FilterModel.new(PARAMS_MR2)
    #  fm.user = USER
    #
    #  data = Qed::Mongodb::MapReduce::Performer.mapreduce(fm, MAPREDUCE_CONFIG).find().to_a
    #  assert_equal 1, data.size
    #
    #  data = data.first
    #  assert_equal fm.filter[PRODUCT_NAME.to_sym][:value], data["_id"]
    #  # assert many more things, like numbers etc
    #end


    #
    #should "return many mapreduced trackings" do
    #  fm = FilterModel.new(PARAMS_MR3)
    #  fm.user = USER
    #
    #  data = Qed::Mongodb::MapReduce::Performer.mapreduce(fm, MAPREDUCE_CONFIG).find().to_a
    #
    #  puts data.inspect
    #
    #end

    context "performing mapreduce in the Universe" do
      setup do
        Qed::Mongodb::Test::Factory::ScaleOfUniverse.big_crunch
        Qed::Mongodb::Test::Factory::ScaleOfUniverse.big_bang(Qed::Mongodb::Test::Factory::ScaleOfUniverse::EXAMPLE_UNIVERSE)
        @fm = FilterModel.new(Qed::Mongodb::Test::Factory::ScaleOfUniverse::PARAMS_SCALE_OF_UNIVERSE)
        @fm.user = USER
      end

      context "to create a top view statistic" do
        should "work" do


        end
      end

      context "to create a drilldown statistic one step below the top view" do
        should "work" do

        end
      end

      context "to create a drilldown statistic two steps below the top view" do
        should "work" do

        end
      end

      context "to create a drilldown statistic three steps below the top view" do
        should "work" do

        end
      end

      context "to create a drilldown statistic four steps below the top view" do
        #should "work" do
        #  @fm.drilldown_level_current = 3
        #  data = Qed::Mongodb::MapReduce::Performer.mapreduce(@fm, MAPREDUCE_CONFIG).find().to_a
        #  puts data.inspect
        #
        #  # filter nil elements, for now
        #  # TODO: can we do something about objects that are not within this map-reduce scope?
        #  # TODO: this will be kinda important with subsequent mapreduce requests, where those
        #  # TODO: might yield some new information (since the fall into a mapreduced scope again)
        #  data = data.select{ |d| !d["_id"].nil? }
        #
        #  assert_equal  Qed::Mongodb::Test::Factory::ScaleOfUniverse.amount_of_types_in_same_dimension(data.first["_id"]), data.size
        #
        #  data.each do |mr_result|
        #    assert_equal  Qed::Mongodb::Test::Factory::ScaleOfUniverse.amount_of_objects_in_universe(mr_result["_id"]), mr_result["value"]["count"]
        #  end
        #end
      end

      context "to create a drilldown statistic five steps below the top view" do
        should "work" do
          @fm.drilldown_level_current = 4
          performer = Qed::Mongodb::MapReduce::Performer.new(@fm, MAPREDUCE_CONFIG)
          data = performer.mapreduce.find().to_a
          #puts data.inspect

          # filter nil elements, for now
          # TODO: can we do something about objects that are not within this map-reduce scope?
          # TODO: this will be kinda important with subsequent mapreduce requests, where those
          # TODO: might yield some new information (since the fall into a mapreduced scope again)
          data = data.select{ |d| !d["_id"].nil? }

          assert_equal  Qed::Mongodb::Test::Factory::ScaleOfUniverse.line_items_with_same_value_in_dimension(data.first["_id"]), data.size

          data.each do |mr_result|
            assert_equal  Qed::Mongodb::Test::Factory::ScaleOfUniverse.amount_of_objects_in_universe(mr_result["_id"]), mr_result["value"]["count"]
          end
        end
      end
    end

    #context "creating a filtered but not mapreduced view" do
    #  should "work" do
    #    fm = FilterModel.new(PARAMS_MR3)
    #    fm.user = USER
    #    fm.drilldown_level_current = 2
    #
    #    data = Qed::Mongodb::MapReduce::Performer.mapreduce(fm, MAPREDUCE_CONFIG).find().to_a
    #
    #    puts data.inspect
    #  end
    #end

    context "performing mapreduce on a WorldWideBusiness" do
      setup do
        Qed::Mongodb::Test::Factory::WorldWideBusiness.sell_out
        Qed::Mongodb::Test::Factory::WorldWideBusiness.startup(Qed::Mongodb::Test::Factory::WorldWideBusiness::WORLD_WIDE_BUSINESS)
        @fm = FilterModel.new(Qed::Mongodb::Test::Factory::WorldWideBusiness::PARAMS_WORLD_WIDE_BUSINESS)
        @fm.user = USER
      end

      context "on the Dimension location" do
        setup do
           @fm.drilldown_level_current = 0
        end

        context "to create a the top view statistic" do
          setup do
            @fm.view = Qed::Mongodb::Test::Factory::WorldWideBusiness::VIEW_LOC_DIM0
            @performer = Qed::Mongodb::MapReduce::Performer.new(@fm, MAPREDUCE_CONFIG)
            @data = @performer.mapreduce.find().to_a
            @mr_key = @performer.get_mr_key.join(",")

            #puts "key: #{mr_key.inspect}"
            #puts "data: #{data.inspect}"
            #puts Qed::Mongodb::Test::Factory::WorldWideBusiness.different_values_for_mr.inspect
          end

          should "return the correct number of mapreduced datarows" do
            assert_equal Qed::Mongodb::Test::Factory::WorldWideBusiness.different_values_for_mr[@mr_key].size, @data.size
          end
                    
          should "return the correct amount of same data values" do
            @data.each do |mr_result|
              assert_equal Qed::Mongodb::Test::Factory::WorldWideBusiness.line_items_with_same_value_in_dimension(@data.first["_id"], :location), mr_result["value"]["count"].to_i
            end
          end
        end

        context "to create a drilldown statistic one level below the top view" do
          setup do
            @fm.view = Qed::Mongodb::Test::Factory::WorldWideBusiness::VIEW_LOC_DIM1
            @performer = Qed::Mongodb::MapReduce::Performer.new(@fm, MAPREDUCE_CONFIG)
            @data = @performer.mapreduce.find().to_a
            @mr_key = @performer.get_mr_key.join(",")

            #puts "key: #{@mr_key.inspect}"
            #puts "data: #{@data.inspect}"
            #puts Qed::Mongodb::Test::Factory::WorldWideBusiness.different_values_for_mr.inspect
          end

          should "return the correct number of mapreduced datarows" do
            assert_equal Qed::Mongodb::Test::Factory::WorldWideBusiness.different_values_for_mr[@mr_key].size, @data.size
          end

          should "return the correct amount of same data values" do
            @data.each do |mr_result|
              assert_equal Qed::Mongodb::Test::Factory::WorldWideBusiness.line_items_with_same_value_in_dimension(mr_result["_id"], :location), mr_result["value"]["count"].to_i
            end
          end
        end

        context "to create a drilldown statistic two level below the top view" do
          setup do
            @fm.view = Qed::Mongodb::Test::Factory::WorldWideBusiness::VIEW_LOC_DIM2
            @performer = Qed::Mongodb::MapReduce::Performer.new(@fm, MAPREDUCE_CONFIG)
            @data = @performer.mapreduce.find().to_a
            @mr_key = @performer.get_mr_key.join(",")

            #puts "key: #{@mr_key.inspect}"
            #puts "data: #{@data.inspect}"
            #puts Qed::Mongodb::Test::Factory::WorldWideBusiness.different_values_for_mr.inspect
          end

          should "return the correct number of mapreduced datarows" do
            assert_equal Qed::Mongodb::Test::Factory::WorldWideBusiness.different_values_for_mr[@mr_key].size, @data.size
          end

          should "return the correct amount of same data values" do
            @data.each do |mr_result|
              assert_equal Qed::Mongodb::Test::Factory::WorldWideBusiness.line_items_with_same_value_in_dimension(mr_result["_id"], :location), mr_result["value"]["count"].to_i
            end
          end
        end

        context "to create a drilldown statistic three level below the top view" do
          setup do
            @fm.view = Qed::Mongodb::Test::Factory::WorldWideBusiness::VIEW_LOC_DIM3
            @performer = Qed::Mongodb::MapReduce::Performer.new(@fm, MAPREDUCE_CONFIG)
            @data = @performer.mapreduce.find().to_a
            @mr_key = @performer.get_mr_key.join(",")

            #puts "key: #{@mr_key.inspect}"
            #puts "data: #{@data.inspect}"
            #puts Qed::Mongodb::Test::Factory::WorldWideBusiness.different_values_for_mr.inspect
          end

          should "return the correct number of mapreduced datarows" do
            assert_equal Qed::Mongodb::Test::Factory::WorldWideBusiness.different_values_for_mr[@mr_key].size, @data.size
          end

          should "return the correct amount of same data values" do
            @data.each do |mr_result|
              assert_equal Qed::Mongodb::Test::Factory::WorldWideBusiness.line_items_with_same_value_in_dimension(mr_result["_id"], :location), mr_result["value"]["count"].to_i
            end
          end
        end
      end
    end

    context "performing a query on a WorldWideBusiness" do
      setup do
        Qed::Mongodb::Test::Factory::WorldWideBusiness.sell_out
        Qed::Mongodb::Test::Factory::WorldWideBusiness.startup(Qed::Mongodb::Test::Factory::WorldWideBusiness::WORLD_WIDE_BUSINESS)
        @fm = FilterModel.new(Qed::Mongodb::Test::Factory::WorldWideBusiness::PARAMS_WORLD_WIDE_BUSINESS)
        @fm.user = USER
      end

      context "on the Dimension location" do
        setup do
           @fm.drilldown_level_current = 2
        end


        context "to create a filter but unreduced view on the data" do
          context "on DIM3" do
            setup do
              @fm.view = Qed::Mongodb::Test::Factory::WorldWideBusiness::VIEW_LOC_DIM0
              @performer = Qed::Mongodb::MapReduce::Performer.new(@fm, MAPREDUCE_CONFIG)
              @data = @performer.mapreduce.find().to_a
              @mr_key = @performer.get_mr_key.join(",")
              puts "data: #{@data.inspect}"
            end

            # TODO: we need something to test the filtering/query thingy
            # TODO: below this is a workaround
            should "return the correct number of filtered datarows" do
              assert_equal Qed::Mongodb::Test::Factory::WorldWideBusiness.line_items_with_same_value_in_dimension(@data.first["value"]["DIM_LOC_0"], :location), @data.size
            end
          end
        end
      end
    end
  end
end
