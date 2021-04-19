require 'test_helper'

module PushType
  class FieldTypeTest < ActiveSupport::TestCase

    let(:node)  { FactoryBot.create :node }
    let(:field) { PushType::FieldType.new :foo, node, opts }
    
    describe 'default' do
      let(:opts) { {} }
      it { _(field.name).must_equal :foo }
      it { _(field.model).must_equal node }
      it { _(field.kind).must_equal :field }
      it { _(field.primitive).must_equal PushType::Primitives::StringType }

      it { _(field.json_primitive).must_equal :string }
      it { _(field.template).must_equal 'default' }
      it { _(field.label).must_equal 'Foo' }
      it { _(field.form_helper).must_equal :text_field }
      it { _(field.html_options).must_equal({}) }
      it { _(field.field_options).must_equal({}) }
      it { _(field.multiple?).must_equal false  }
    end

    describe 'with options' do
      let(:opts)  { { json_primitive: :number, template: 'my_template', label: 'Bar', form_helper: :number_field, html_options: { some: 'opts' }, field_options: { more: 'opts'} } }
      it { _(field.json_primitive).must_equal :number }
      it { _(field.template).must_equal opts[:template] }
      it { _(field.label).must_equal opts[:label] }
      it { _(field.form_helper).must_equal opts[:form_helper] }
      it { _(field.html_options).must_equal opts[:html_options] }
      it { _(field.field_options).must_equal opts[:field_options] }
    end

  end
end
