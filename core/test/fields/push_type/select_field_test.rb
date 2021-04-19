require 'test_helper'

module PushType
  class SelectFieldTest < ActiveSupport::TestCase

    class TestPage < PushType::Node
      field :foo, :select, choices: [['AAA', 'a'], ['BBB', 'b']]
      field :bars, :select, multiple: true, choices: -> { [['XXX', 'x'], ['YYY', 'y']] }
    end

    let(:node)  { TestPage.create FactoryBot.attributes_for(:node, foo: 'b', bars: ['x', 'y']) }
    let(:foo)   { node.fields[:foo] }
    let(:bars)  { node.fields[:bars] }

    it { _(foo.json_primitive).must_equal :string }
    it { _(foo.template).must_equal 'select' }
    it { _(foo.field_options.keys).must_include :include_blank }
    it { _(foo.html_options.keys).must_include :multiple }
    it { _(foo).wont_be :multiple? }
    it { _(foo.json_value).must_equal 'b' }
    it { _(foo.value).must_equal 'b' }
    it { _(foo.choices).must_equal [['AAA', 'a'], ['BBB', 'b']] }

    it { _(bars.json_primitive).must_equal :array }
    it { _(bars).must_be :multiple? }
    it { _(bars.json_value).must_equal ['x', 'y'] }
    it { _(bars.value).must_equal ['x', 'y'] }
    it { _(bars.choices).must_equal [['XXX', 'x'], ['YYY', 'y']] }

    it { _(node.foo).must_equal 'b' }
    it { _(node.bars).must_equal ['x', 'y'] }

  end
end