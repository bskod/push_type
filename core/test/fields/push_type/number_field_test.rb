require 'test_helper'

module PushType
  class NumberFieldTest < ActiveSupport::TestCase

    class TestPage < PushType::Node
      field :foo, :number
      field :bar, :number
    end

    let(:node)  { TestPage.create FactoryBot.attributes_for(:node, foo: 1, bar: 1.234) }
    let(:foo)   { node.fields[:foo] }
    let(:bar)   { node.fields[:bar] }

    
    it { _(foo.json_primitive).must_equal :number }
    it { _(foo.form_helper).must_equal :number_field }
    it { _(foo.json_value).must_equal 1 }
    it { _(foo.value).must_equal 1 }
    it { _(bar.json_value).must_equal 1.234 }
    it { _(bar.value).must_equal 1.234 }

    it { _(node.foo).must_equal 1 }
    it { _(node.bar).must_equal 1.234 }

  end
end