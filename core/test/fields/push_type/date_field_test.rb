require 'test_helper'

module PushType
  class DateFieldTest < ActiveSupport::TestCase

    class TestPage < PushType::Node
      field :foo, :date
    end

    let(:node)  { TestPage.create FactoryBot.attributes_for(:node, foo: date.to_s) }
    let(:date)  { Date.today }
    let(:field) { node.fields[:foo] }
    
    it { _(field.template).must_equal 'date' }
    it { _(field.form_helper).must_equal :date_field }
    it { _(field.json_value).must_equal date.to_s }
    it { _(field.value).must_equal date }

    it { _(node.foo).must_equal date }

  end
end