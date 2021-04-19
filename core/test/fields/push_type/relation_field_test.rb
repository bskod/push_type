require 'test_helper'

module PushType
  class RelationFieldTest < ActiveSupport::TestCase

    class TestPage < PushType::Node
      field :page_id, :relation
      field :bar_ids, :relation, to: 'push_type/node', multiple: true
      field :baz_ids, :relation, to: :page, scope: -> { order(created_at: :desc).all }
      field :qux_ids, :relation, to: :page, scope: -> { all.hash_tree }
    end

    before do
      @pages  = 4.times.map { Page.create FactoryBot.attributes_for(:node) }
      @bars   = 2.times.map { TestPage.create FactoryBot.attributes_for(:node) }
    end

    let(:node)  { TestPage.create FactoryBot.attributes_for(:node, page_id: rel.id, bar_ids: @bars.map(&:id)) }
    let(:rel)   { @pages.first }
    let(:foo)   { node.fields[:page_id] }
    let(:bar)   { node.fields[:bar_ids] }
    let(:baz)   { node.fields[:baz_ids] }
    let(:qux)   { node.fields[:qux_ids] }

    it { _(foo.json_primitive).must_equal :string }
    it { _(foo.template).must_equal 'relation' }
    it { _(foo).wont_be :multiple? }
    it { _(foo.label).must_equal 'Page' }
    it { _(foo.html_options.keys).must_include :multiple }
    it { _(foo.json_value).must_equal rel.id }
    it { _(foo.value).must_equal rel.id }
    it { _(foo.choices.size).must_equal 4 }
    it { _(foo.choices.map { |c| c[:value] }).must_include rel.id }
    it { _(foo.relation_name).must_equal 'page' }
    it { _(foo.relation_class).must_equal Page }
    it { _(foo.relation_items).must_be_kind_of ActiveRecord::Relation }

    it { _(bar.json_primitive).must_equal :array }
    it { _(bar).must_be :multiple? }
    it { _(bar.label).must_equal 'Bars' }
    it { _(bar.relation_name).must_equal 'bars' }
    it { _(bar.relation_class).must_equal PushType::Node }
    it { _(bar.json_value).must_equal @bars.map(&:id) }
    it { _(bar.value).must_equal @bars.map(&:id) }
    it { _(bar.choices.size).must_equal 7 }
    it { _(bar.relation_items).must_be_kind_of ActiveRecord::Relation }

    it { _(baz.relation_class).must_equal Page }
    it { _(baz.choices.size).must_equal 4 }
    it { _(baz.relation_items).must_be_kind_of ActiveRecord::Relation }
    it { _(qux.choices.size).must_equal 4 }
    it { _(qux.relation_items).must_be_kind_of Hash }

    it { _(node.page_id).must_equal rel.id }
    it { _(node.page).must_equal rel }
    it { _(node.bar_ids).must_equal @bars.map(&:id) }
    it { _(node.bars.sort).must_equal @bars.sort }

    describe 'with missing relations' do
      before do
        @pages.first.destroy
        @bars.first.destroy
      end

      it { _(node.page).must_be_nil }
      it { _(node.bars.size).must_equal 1 }
    end

  end
end