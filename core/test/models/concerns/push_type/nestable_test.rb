require 'test_helper'

module PushType
  class NestableTest < ActiveSupport::TestCase

    class TestPage < PushType::Node
    end

    let(:page) { TestPage.new }
    let(:roots) { PushType.root_nodes }

    before do
      TestPage.instance_variable_set '@child_nodes', nil
      TestPage.instance_variable_set '@child_order', nil
    end
    after do
      TestPage.instance_variable_set '@child_nodes', nil
      TestPage.instance_variable_set '@child_order', nil
    end

    describe '.has_child_nodes' do
      describe 'defaults' do
        it { _(TestPage.child_nodes).must_equal roots }
        it { _(page.child_nodes).must_equal roots }
        it { _(page).must_be :sortable? }
      end

      describe 'when none' do
        before { TestPage.has_child_nodes false }
        it { _(TestPage.child_nodes).must_equal [] }
        it { _(page.child_nodes).must_equal [] }
        it { _(page).wont_be :descendable? }
      end

      describe 'when all' do
        before { TestPage.has_child_nodes :all }
        it { _(TestPage.child_nodes).must_equal roots }
        it { _(page.child_nodes).must_equal roots }
        it { _(page).must_be :descendable? }
      end

      describe 'when specific' do
        before { TestPage.has_child_nodes :page }
        it { _(TestPage.child_nodes).must_equal ['page'] }
        it { _(page.child_nodes).must_equal ['page'] }
        it { _(page).must_be :descendable? }
      end

      describe 'when nonsense' do
        before { TestPage.has_child_nodes :foo, :bar }
        it { _(TestPage.child_nodes).must_equal [] }
        it { _(page.child_nodes).must_equal [] }
        it { _(page).wont_be :descendable? }
      end

      describe 'without options' do
        before { TestPage.has_child_nodes :page, :test_page }
        it { _(TestPage.child_nodes).must_equal ['page', 'test_page'] }
        it { _(page.custom_child_order?).must_equal false }
        it { _(page).must_be :sortable? }
        it { _(page.children.order_values).must_include 'sort_order' }
      end

      describe 'with options' do
        before { TestPage.has_child_nodes :page, :test_page, order: 'name ASC' }
        it { _(TestPage.child_nodes).must_equal ['page', 'test_page'] }
        it { _(page.custom_child_order?).must_equal true }
        it { _(page).wont_be :sortable? }
        it { _(page.children.order_values).must_include 'name ASC' }
      end

      describe 'with template' do
        before { TestPage.has_child_nodes :page, :test_page, order: :blog }
        it { _(TestPage.child_nodes).must_equal ['page', 'test_page'] }
        it { _(page.custom_child_order?).must_equal true }
        it { _(page).wont_be :sortable? }
        it { _(page.children.order_values).must_equal ['published_at DESC', 'created_at DESC'] }
      end
    end

    describe 'parent validation' do
      let(:parent)  { TestPage.create title: 'parent', slug: 'parent' }
      subject       { Page.new title: 'child', slug: 'child', parent: parent }

      describe 'with invalid child' do
        before { TestPage.has_child_nodes false }
        it 'should not be valid' do
          _(subject).wont_be :valid?
          _(subject.errors.keys).must_include :parent_id
        end
      end

      describe 'with valid child' do
        before { TestPage.has_child_nodes :page }
        it 'should be valid' do
          _(subject).must_be :valid?
          _(subject.errors.keys).wont_include :parent_id
        end
      end
    end

  end
end