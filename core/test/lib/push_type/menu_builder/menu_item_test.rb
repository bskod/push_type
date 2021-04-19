require 'test_helper'

module PushType
  module MenuBuilder
    class MenuItemTest < ActiveSupport::TestCase

      let(:item) { MenuBuilder::MenuItem.new :foo }

      it { _(item.key).must_equal :foo }
      it { _(item.text).must_equal 'Foo' }
      it { _(item.link).must_be_nil }
      it { _(item.active).must_equal false }
      it { _(item.element).must_equal :li }
      it { _(item.item_options).must_be_instance_of Hash }
      it { _(item.link_options).must_be_instance_of Hash }
      it { _(item.active_class).must_be_nil }

      describe '#submenu' do
        it 'should create a new menu' do
          _(item.submenu).must_be_instance_of MenuBuilder::Menu
        end
        it 'should use existing submenu if present' do
          menu = item.submenu
          _(item.submenu).must_equal menu
        end
      end

      describe '#validate!' do
        describe 'without all attributes' do
          it { expect { item.validate! }.must_raise RuntimeError }
        end
        describe 'with all attributes' do
          before { item.link = '/foobar' }
          it { _(item.validate!).must_equal true }
        end
      end

    end
  end
end
