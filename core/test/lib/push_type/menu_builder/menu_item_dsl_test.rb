require 'test_helper'

module PushType
  module MenuBuilder
    class Dsl::MenuItemTest < ActiveSupport::TestCase

      let(:item) { MenuBuilder::MenuItem.new(:bar) }

      describe '.build' do
        before do
          MenuBuilder::Dsl::MenuItem.build(item) do
            text 'FooBar'
            link '/foobar'
            active { 1 == 1 }
            element :div
            item_options class: 'foo-bar', data: { foo: 'bar' }
            link_options class: 'foo-baz', data: { foo: 'baz' }
            active_class 'foo-active'
          end
        end

        it { _(item.text).must_equal 'FooBar' }
        it { _(item.link).must_equal '/foobar' }
        it { _(item.active.call).must_equal true }
        it { _(item.element).must_equal :div }
        it { _(item.item_options[:class]).must_equal 'foo-bar' }
        it { _(item.item_options[:data][:foo]).must_equal 'bar' }
        it { _(item.link_options[:class]).must_equal 'foo-baz' }
        it { _(item.link_options[:data][:foo]).must_equal 'baz' }
        it { _(item.active_class).must_equal 'foo-active' }
      end

    end
  end
end
