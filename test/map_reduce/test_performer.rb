require File.dirname(__FILE__) + '/../test_helper.rb'

class TestMapReducePerformer < Test::Unit::TestCase
  should "load" do
    Qed::Mongodb::MapReduce::Performer
  end

  context "calling function mapreduce" do
    should "throw an exception if option is not a hash" do
      assert_raise Qed::Mongodb::Exceptions::OptionMisformed do
        Qed::Mongodb::MapReduce::Performer.mapreduce([], MAPREDUCE_CONFIG)
      end
    end

    should "throw an exception if option doesn't have the 'filter' key" do
      fm = FilterModel.new(PARAMS_MR2)
      assert_raise Qed::Mongodb::Exceptions::OptionMisformed do
        Qed::Mongodb::MapReduce::Performer.mapreduce({:abc => fm}, MAPREDUCE_CONFIG)
      end
    end

    should "throw an exception if the 'filter' value is not a FilterModel-Object" do
      assert_raise Qed::Mongodb::Exceptions::OptionMisformed do
        Qed::Mongodb::MapReduce::Performer.mapreduce({:filter => "fm"}, MAPREDUCE_CONFIG)
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
        @fm = FilterModel.new(PARAMS_SCALE_OF_UNIVERSE)
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
          data = Qed::Mongodb::MapReduce::Performer.mapreduce(@fm, MAPREDUCE_CONFIG).find().to_a
          puts data.inspect

          # filter nil elements, for now
          # TODO: can we do something about objects that are not within this map-reduce scope?
          # TODO: this will be kinda important with subsequent mapreduce requests, where those
          # TODO: might yield some new information (since the fall into a mapreduced scope again)
          data = data.select{ |d| !d["_id"].nil? }

          assert_equal  Qed::Mongodb::Test::Factory::ScaleOfUniverse.amount_of_types_in_same_dimension(data.first["_id"]), data.size

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


  end
end
