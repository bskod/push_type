require 'test_helper'

module PushType
  class CoreExtTest < ActiveSupport::TestCase

    describe 'to_bool' do
      # Strings
      it { _(''.to_bool).must_equal false }
      it { _('0'.to_bool).must_equal false }
      it { _('no'.to_bool).must_equal false }
      it { _('false'.to_bool).must_equal false }
      it { _('1'.to_bool).must_equal true }
      it { _('anything else'.to_bool).must_equal true }

      # Fixnums
      it { _(0.to_bool).must_equal false }
      it { _(1.to_bool).must_equal true }
      it { _(1234.to_bool).must_equal true }

      # Booleans
      it { _(false.to_i).must_equal 0 }
      it { _(false.to_bool).must_equal false }
      it { _(true.to_i).must_equal 1 }
      it { _(true.to_bool).must_equal true }

      # Nils
      it { _(nil.to_bool).must_equal false }
    end
    
  end
end