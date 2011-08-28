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

    context "an empty hash" do
      setup do
        @mrp = Qed::Filter::MapReduceParams.new()
      end

      context "and adding map reduce params later via add_emit_key with key and value parameters" do
        setup do
          @mrp.add_emit_key(EMIT_KEY1, EMIT_VALUE1)
          @mrp.add_emit_key(EMIT_KEY2, EMIT_VALUE2)
        end

        should "generate the correct hash" do
          assert_equal EMIT_KEYS_RESULTS_HASH, @mrp.serializable_hash
        end

        should "generate the correct params in url format" do
          assert_equal EMIT_AS_URL, @mrp.url
        end
      end

      context "and adding duplicate map reduce params later via add_emit_key with key and value parameters" do
        setup do
          @mrp.add_emit_key(EMIT_KEY1, EMIT_VALUE1)
          @mrp.add_emit_key(EMIT_KEY2, EMIT_VALUE2)
          @mrp.add_emit_key(EMIT_KEY1, EMIT_VALUE1)
          @mrp.add_emit_key(EMIT_KEY2, EMIT_VALUE2)
          @mrp.add_emit_key(EMIT_KEY1, EMIT_VALUE1)
          @mrp.add_emit_key(EMIT_KEY2, EMIT_VALUE2)
        end

        should "rejected the all but the latest duplicate generate the correct hash" do
          assert_equal EMIT_KEYS_RESULTS_HASH, @mrp.serializable_hash
        end

        should "generate the correct params in url format" do
          assert_equal EMIT_AS_URL, @mrp.url
        end
      end

      context "and adding one map reduce param later via add_emit_key with key only" do
        setup do
          @mrp.add_emit_key(EMIT_KEY1)
        end

        should "create the correct url with default value -1" do
          assert_equal EMIT_AS_URL_KEY1_VALUE_DEFAULT, @mrp.url
        end

        should "return an integer as value if accessed directly" do
          assert_equal 1, @mrp.emit_keys.size
          assert @mrp.emit_keys.first.value.is_a?(Fixnum), "Should be an fixnum-object"
          assert_equal EMIT_VALUE_DEFAULT, @mrp.emit_keys.first.value
        end
      end
    end
  end
end