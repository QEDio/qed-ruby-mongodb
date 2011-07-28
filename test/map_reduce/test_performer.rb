require File.dirname(__FILE__) + '/../test_helper.rb'

class TestMapReducePerformer < Test::Unit::TestCase
  should "load" do
    Qed::Mongodb::MapReduce::Performer
  end

  context "calling function mapreduce" do
    should "throw an exception if option is not a hash" do
      assert_raise Qed::Mongodb::Exceptions::OptionMisformed do
        Qed::Mongodb::MapReduce::Performer.mapreduce([])
      end
    end

    should "throw an exception if option doesn't have the 'filter' key" do
      fm = FilterModel.new(PARAMS)
      assert_raise Qed::Mongodb::Exceptions::OptionMisformed do
        Qed::Mongodb::MapReduce::Performer.mapreduce({:abc => fm})
      end
    end

    should "throw an exception if the 'filter' value is not a FilterModel-Object" do
      assert_raise Qed::Mongodb::Exceptions::OptionMisformed do
        Qed::Mongodb::MapReduce::Performer.mapreduce({:filter => "fm"})
      end
    end

    should "return one mapreduced result for a drilldown level of 0 and a filter for Elektromobil" do
      fm = FilterModel.new(PARAMS)
      fm.user = USER

      data = Qed::Mongodb::MapReduce::Performer.mapreduce(fm).find().to_a
      assert_equal 1, data.size

      data = data.first
      assert_equal fm.filter[PRODUCT_NAME.to_sym][:value], data["_id"]
      # assert many more things, like numbers etc
    end

    should "return many mapreduced trackings" do
      fm = FilterModel.new(PARAMS_TRACKING)
      fm.user = USER

      data = Qed::Mongodb::MapReduce::Performer.mapreduce(fm).find().to_a

      #puts data.inspect

    end
  end
end
