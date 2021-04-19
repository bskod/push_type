require 'test_helper'

module PushType
  class MatrixFieldTest < ActiveSupport::TestCase

    class TestLocation < PushType::Structure
      field :key
    end

    class TestPage < PushType::Node
      field :foo, :matrix, grid: false do
        field :key, :string
        field :val, :text
      end
      field :bar, :matrix, class: 'push_type/matrix_field_test/test_location'
    end

    let(:node)  { TestPage.create FactoryBot.attributes_for(:node, foo: val, bar: [{key: '123'}]) }
    let(:val)   { [{ key: 'a', val: 'b' }, { key: 'x', val: 'y' }] }
    let(:field) { node.fields[:foo] }

    it { _(field.template).must_equal 'matrix' }
    it { _(field.fields.keys).must_include :key, :val }
    it { _(field.fields.values.map { |v| v.class }).must_include PushType::StringField, PushType::TextField }
    it { _(field.json_value).must_equal [{ 'key' => 'a', 'val' => 'b' }, { 'key' => 'x', 'val' => 'y' }] }
    it { _(field.value.all? { |v| v.class.name == 'PushType::Structure' }).must_equal true }
    it { _(field.value.first.fields.keys).must_include :key, :val }
    it { _(field.value[0].key).must_equal 'a' }
    it { _(field.value[1].val).must_equal 'y' }

    it { _(node.bar.first).must_be_instance_of TestLocation }
    it { _(node.bar.first.class.ancestors).must_include PushType::Structure }
    it { _(node.fields[:bar].grid?).must_equal true }
    it { _(node.fields[:foo].grid?).must_equal false }

  end
end