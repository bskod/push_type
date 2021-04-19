require 'test_helper'

module PushType
  class UserTest < ActiveSupport::TestCase
    let(:user) { User.new }

    it { _(user).wont_be :valid? }

    it 'should be valid with required attributes' do
      user.attributes = FactoryBot.attributes_for :user
      _(user).must_be :valid?
    end

    describe '#initials' do
      let(:user_one)    { User.new name: 'Joe' }
      let(:user_two)    { User.new name: 'Joe Bloggs' }
      let(:user_three)  { User.new name: 'Joe Smithe Henley-Bloggs' }
      it { _(user_one.initials).must_equal 'J' }
      it { _(user_two.initials).must_equal 'JB' }
      it { _(user_three.initials).must_equal 'JH' }
    end

  end
end
