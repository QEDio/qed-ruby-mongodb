require File.dirname(__FILE__) + '/../helper.rb'

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

    should "return bla" do
      fm = FilterModel.new(PARAMS1)
      fm.user = USER
      puts Qed::Mongodb::MapReduce::Performer.
        mapreduce(fm).find().count().inspect
    end
  end
end
