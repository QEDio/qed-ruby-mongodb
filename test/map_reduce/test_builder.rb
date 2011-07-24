require File.dirname(__FILE__) + '/../helper.rb'

class TestMapReduceBuilder < Test::Unit::TestCase
  should "load" do
    Qed::Mongodb::MapReduce::Builder
  end
end


