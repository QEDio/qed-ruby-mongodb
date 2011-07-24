require File.dirname(__FILE__) + '/../helper.rb'

class TestMapReduceConfig < Test::Unit::TestCase
  should "load" do
    Qed::Mongodb::MapReduce::Config
  end
end