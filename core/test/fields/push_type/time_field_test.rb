require 'test_helper'

module PushType
  class TimeFieldTest < ActiveSupport::TestCase

    class TestPage < PushType::Node
      field :foo, :time
    end

    let(:node)  { TestPage.create FactoryBot.attributes_for(:node, foo: val) }
    let(:val)   { '15:00' }
    let(:field) { node.fields[:foo] }
    
    it { _(field.template).must_equal 'date' }
    it { _(field.form_helper).must_equal :time_field }
    it { _(field.json_value).must_equal val }
    it { _(field.value).must_equal val.to_time }

    it { _(node.foo).must_be_instance_of Time }
    it { _(node.foo.hour).must_equal 15 }

  end
end