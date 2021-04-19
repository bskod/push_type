require 'test_helper'

module PushType
  class StructureFieldTest < ActiveSupport::TestCase

    class TestPage < PushType::Node
      field :foo, :structure do
        field :key, :string
        field :val, :text
      end
      field :location, :structure
      field :bar, :structure, class: :location
    end

    let(:node)  { TestPage.create FactoryBot.attributes_for(:node, foo: val) }
    let(:val)   { { key: 'a', val: 'b' } }
    let(:field) { node.fields[:foo] }

    it { _(field.template).must_equal 'structure' }
    it { _(field.fields.keys).must_include :key, :val }
    it { _(field.fields.values.map { |v| v.class }).must_include PushType::StringField, PushType::TextField }
    it { _(field.json_value).must_equal({ 'key' => 'a', 'val' => 'b' }) }
    it { _(field.value.class.name).must_equal 'PushType::Structure' }
    it { _(field.value.fields.keys).must_include :key, :val }
    it { _(field.value.key).must_equal 'a' }
    it { _(field.value.val).must_equal 'b' }

    it { _(node.foo.class.ancestors).must_include PushType::Structure }
    it { _(node.location).must_be_instance_of Location }
    it { _(node.bar).must_be_instance_of Location }
    it { _(node.location.class.ancestors).must_include PushType::Structure }
    it { _(node.bar.class.ancestors).must_include PushType::Structure }

  end
end