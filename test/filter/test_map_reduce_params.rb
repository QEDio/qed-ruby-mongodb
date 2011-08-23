require File.dirname(__FILE__) + '/../test_helper.rb'

class TestMapReduceParams < Test::Unit::TestCase
  context "create a MapReduceParams Object from" do
    context "a params like from the webbrowser" do
      setup do
        @mrp    = Qed::Filter::MapReduceParams.new(:emit_keys => EMIT_KEYS_LIKE_URL_PARAMS )
      end

      should "execute correctly" do
        assert_equal EMIT_KEYS_RESULTS_HASH, @mrp.serializable_hash
      end
    end

    context "params in ARRAY form" do
      setup do
        @mrp    = Qed::Filter::MapReduceParams.new(:emit_keys => EMIT_KEYS_LIKE_ARRAY  )
      end

      should "execute correctly" do
        assert_equal EMIT_KEYS_RESULTS_HASH, @mrp.serializable_hash
      end
    end

    context "params in HASH form" do
      setup do
        @mrp    = Qed::Filter::MapReduceParams.new(:emit_keys => EMIT_KEYS_LIKE_HASH  )
      end

      should "execute correctly" do
        assert_equal EMIT_KEYS_RESULTS_HASH, @mrp.serializable_hash
      end
    end
  end
end