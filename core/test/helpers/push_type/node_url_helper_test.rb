require 'test_helper'

module PushType
  class NodeUrlHelperTest < ActionView::TestCase

    let(:node) { FactoryBot.create :node, slug: 'test1' }

    describe '#node_path' do
      it { _(node_path(node)).must_equal '/test1' }
      it { _(node_path('test2')).must_equal '/test2' }
    end

    describe '#node_url' do
      it { _(node_url(node)).must_equal 'http://test.host/test1' }
      it { _(node_url('test2')).must_equal 'http://test.host/test2' }
    end

  end
end
