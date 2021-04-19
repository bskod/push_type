require 'test_helper'

module PushType
  class RepeaterFieldTest < ActiveSupport::TestCase

    class TestPage < PushType::Node
      field :foo, :repeater
      field :bar, :repeater, repeats: :number
      field :baz, :repeater, form_helper: :telephone_field
    end

    let(:node)  { TestPage.create FactoryBot.attributes_for(:node, foo: val) }
    let(:val)   { ['abc', 'xyz', '123'] }
    let(:field) { node.fields[:foo] }

    it { _(field.template).must_equal 'repeater' }
    it { _(field.json_value).must_equal val }
    it { _(field.value).must_equal val }
    it { _(field.rows).must_be_instance_of Array }
    it { field.rows.all? { |r| _(r.f).must_be_instance_of PushType::StringField } }
    it { _(field.structure.f).must_be_instance_of PushType::StringField }

    it { _(node.fields[:bar].structure.f).must_be_instance_of PushType::NumberField }
    it { node.fields[:bar].rows.all? { |r| _(r.f).must_be_instance_of PushType::NumberField } }
    it { _(node.fields[:baz].structure.f).must_be_instance_of PushType::StringField }
    it { _(node.fields[:baz].form_helper).must_equal :telephone_field }
    it { _(node.fields[:baz].structure.f.form_helper).must_equal :telephone_field }

    it { _(node.foo).must_equal val }

  end
end