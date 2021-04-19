require 'test_helper'

module PushType
  class TagListFieldTest < ActiveSupport::TestCase

    class TestPage < PushType::Node
      field :tags, :tag_list
    end

    let(:node)  { TestPage.create FactoryBot.attributes_for(:node, tags: tags) }
    let(:tags)  { ['a', 'b', 'c'] }
    let(:field) { node.fields[:tags] }

    it { _(field.json_primitive).must_equal :array }
    it { _(field.template).must_equal 'select' }
    it { _(field.html_options.keys).must_include :placeholder }
    it { _(field.html_options.keys).must_include :multiple }
    it { _(field).must_be :multiple? }
    it { _(field.json_value).must_equal tags }
    it { _(field.value).must_equal tags }
    it { _(field.choices).must_equal tags }

    describe 'initialized on node' do
      before do
        TestPage.create FactoryBot.attributes_for(:node, tags: ['foo', 'bar', 'foo'])
        TestPage.create FactoryBot.attributes_for(:node, tags: ['baz', 'bar'])
        TestPage.create FactoryBot.attributes_for(:published_node, tags: ['qux'])
        @first = TestPage.create FactoryBot.attributes_for(:node, tags: ['foo', 'bar', 'qux'])
        TestPage.create FactoryBot.attributes_for(:published_node)
      end

      describe '#with_all_tags' do
        let(:tags) { ['foo', 'foo', 'bar', 'qux'] }
        it { _(TestPage).must_respond_to :with_all_tags }
        it { _(TestPage.with_all_tags(tags)).must_be_kind_of ActiveRecord::Relation }
        it { _(TestPage.with_all_tags(tags).count).must_equal 1 }
        it { _(TestPage.published.with_all_tags(tags).count).must_equal 0 }
        it { _(TestPage.published.with_all_tags('qux').count).must_equal 1 }
      end

      describe '#with_any_tags' do
        let(:tags) { ['foo', 'foo', 'bar', 'qux'] }
        it { _(TestPage).must_respond_to :with_any_tags }
        it { _(TestPage.with_any_tags(tags)).must_be_instance_of Array }
        it { _(TestPage.with_any_tags(tags).count).must_equal 4 }
        it { _(TestPage.with_any_tags(tags).first).must_equal @first }
        it { _(TestPage.published.with_any_tags(tags).count).must_equal 1 }
      end

      describe '#all_tags' do
        it { _(TestPage).must_respond_to :all_tags }
        it { _(TestPage.all_tags).must_equal ['bar', 'baz', 'foo', 'qux'] }
        it { _(TestPage.published.all_tags).must_equal ['qux'] }
        it { _(TestPage.all_tags { TestPage.published }).must_equal ['qux'] }
      end
    end

  end
end