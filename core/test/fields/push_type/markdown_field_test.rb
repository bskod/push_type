require 'test_helper'

module PushType
  class MarkdownFieldTest < ActiveSupport::TestCase

    class TestPage < PushType::Node
      field :foo, :markdown
    end

    let(:node)  { TestPage.create FactoryBot.attributes_for(:node, foo: md) }
    let(:md)    { '**foo** *bar*' }
    let(:field) { node.fields[:foo] }
    
    it { _(field.form_helper).must_equal :text_area }
    it { _(field.json_value).must_equal md }
    it { _(field.value).must_equal md }
    it { _(field.compiled_value.strip).must_equal '<p><strong>foo</strong> <em>bar</em></p>' }

    it { _(node.foo).must_equal md }
    it { _(node.present!.foo.strip).must_equal '<p><strong>foo</strong> <em>bar</em></p>' }

  end
end