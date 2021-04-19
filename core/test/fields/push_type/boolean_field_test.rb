require 'test_helper'

module PushType
  class BooleanFieldTest < ActiveSupport::TestCase

    class TestPage < PushType::Node
      field :foo, :boolean
    end

    let(:node)  { TestPage.create FactoryBot.attributes_for(:node, foo: '1') }
    let(:field) { node.fields[:foo] }
    
    it { _(field.json_primitive).must_equal :boolean }
    it { _(field.form_helper).must_equal :check_box }
    it { _(field.json_value).must_equal true }
    it { _(field.value).must_equal true }

    it { _(node.foo).must_equal true }

  end
end