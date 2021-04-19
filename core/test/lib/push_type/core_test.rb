require 'test_helper'

module PushType
  class CoreTest < ActiveSupport::TestCase

    describe '.version' do
      subject { PushType.version }
      it { _(subject).must_equal PushType::VERSION }
    end

    describe '.config' do
      subject { PushType.config }
      it { _(subject).must_respond_to :root_nodes }
      it { _(subject).must_respond_to :home_slug }
      it { _(subject).must_respond_to :unexposed_nodes }
      it { _(subject).must_respond_to :media_styles }
      it { _(subject).must_respond_to :mailer_sender }
      it { _(subject).must_respond_to :home_slug }
      it { _(subject).must_respond_to :dragonfly_datastore }
      it { _(subject).must_respond_to :dragonfly_datastore_options }
      it { _(subject).must_respond_to :dragonfly_secret }
    end

    describe '.root_nodes' do
      let(:config) { MiniTest::Mock.new }
      it 'should return all nodes by default' do
        config.expect :root_nodes, :all
        PushType.stub :config, config do
          _(PushType.root_nodes.size).must_be :>=, 2
        end
        assert config.verify
      end
    end

    describe '.unexposed_nodes' do
      let(:config) { MiniTest::Mock.new }
      it 'should return empty array by default' do
        config.expect :unexposed_nodes, []
        PushType.stub :config, config do
          _(PushType.unexposed_nodes).must_be_empty
        end
        assert config.verify
      end
    end

    describe '.subclasses_from_list' do
      subject { PushType.subclasses_from_list scope, list }
      describe 'scoped by :node' do
        let(:scope) { :node }
        describe 'searching for :all' do
          let(:list) { :all }
          it { _(subject.size).must_be :>=, 2 }
        end
        describe 'searching for single type' do
          let(:list) { :page }
          it { _(subject).must_equal ['page'] }
        end
        describe 'searching for array with nonexisting types' do
          let(:list) { [:page, :test_page, :foo, :bar] }
          it { _(subject).must_equal ['page', 'test_page'] }
        end
      end
    end

  end
end
