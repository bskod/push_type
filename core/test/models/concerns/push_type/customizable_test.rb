require 'test_helper'

module PushType
  class CustomizableTest < ActiveSupport::TestCase

    class TestPage < PushType::Node
      field :foo
      field :bar, :text
      field :baz, validates: { presence: true }
      field :qux, :number, validates: { presence: true }
    end

    let(:page) { TestPage.new }
    let(:fields) { page.fields }

    it { _(TestPage.fields).must_be_instance_of Hash }
    it { _(fields).must_be_instance_of Hash }

    describe '.field' do
      it { _(fields[:foo]).must_be_instance_of StringField }
      it { _(fields[:bar]).must_be_instance_of TextField }
      it { _(fields[:baz]).must_be_instance_of StringField }
      it { _(TestPage.validators_on(:baz).map(&:class)).must_include ActiveRecord::Validations::PresenceValidator }
      it { _(fields[:qux]).must_be_instance_of NumberField }
      it { _(TestPage.validators_on(:qux).map(&:class)).must_include ActiveRecord::Validations::PresenceValidator }
    end

    describe '#attribute_for_inspect' do
      it { _(page.attribute_for_inspect(:field_store)).must_equal "[:foo, :bar, :baz, :qux]" }
    end

    describe '#attribute_changed?' do
      it { _(page.foo_changed?).must_equal false }
      it { _(page.changes.key?(:foo)).must_equal false }

      it 'returns true when attribute is changed' do
        page.foo = 'value'
        _(page.foo_changed?).must_equal true
      end

      it 'returns true when attribute is changed' do
        page.foo = 'value'
        _(page.changes.key?(:foo)).must_equal true
      end
    end
  end
end