require File.dirname(__FILE__) + '/../test_helper.rb'

class TestMapReduceStore < Test::Unit::TestCase
  should "load" do
    Qed::Mongodb::MapReduce::Store
  end
end