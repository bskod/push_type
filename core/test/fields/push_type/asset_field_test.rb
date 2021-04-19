require 'test_helper'

module PushType
  class AssetFieldTest < ActiveSupport::TestCase

    class TestPage < PushType::Node
      field :foo_id, :asset
    end

    let(:node)  { TestPage.create FactoryBot.attributes_for(:node, foo_id: asset.id) }
    let(:asset) { FactoryBot.create :asset }
    let(:field) { node.fields[:foo_id] }
    
    it { _(field.template).must_equal 'asset' }
    it { _(field.relation_class).must_equal PushType::Asset }
    it { _(field.json_value).must_equal asset.id }
    it { _(field.value).must_equal asset.id }

    it { _(node.foo_id).must_equal asset.id }
    it { _(node.foo).must_equal asset }

    describe 'with missing relations' do
      before do
        asset.destroy
      end

      it { _(node.foo).must_be_nil }
    end

  end
end