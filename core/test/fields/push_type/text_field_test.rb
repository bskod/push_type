require 'test_helper'

module PushType
  class TextFieldTest < ActiveSupport::TestCase

    class TestPage < PushType::Node
      field :foo, :text
    end

    let(:node)  { TestPage.create FactoryBot.attributes_for(:node, foo: val) }
    let(:val)   { 'abc' }
    let(:field) { node.fields[:foo] }
    
    it { _(field.form_helper).must_equal :text_area }
    it { _(field.json_value).must_equal val }
    it { _(field.value).must_equal val }

    it { _(node.foo).must_equal val }

  end
end