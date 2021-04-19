require 'test_helper'

module PushType
  class AssetTest < ActiveSupport::TestCase
    let(:asset) { Asset.new }

    it { _(asset).wont_be :valid? }
    it { _(asset.kind).must_be_nil }
    it { _(asset.description_or_file_name).must_be_nil }
    it { _(asset.preview_thumb).must_be_nil }

    it 'should be valid with required attributes' do
      asset.attributes = FactoryBot.attributes_for :asset
      _(asset).must_be :valid?
    end

    describe '#kind' do
      let(:image) { FactoryBot.create :image_asset }
      let(:audio) { FactoryBot.create :audio_asset }
      let(:video) { FactoryBot.create :video_asset }
      let(:doc)   { FactoryBot.create :document_asset }
      it { _(image.kind).must_equal :image }
      it { _(image).must_be :image? }
      it { _(image).wont_be :audio? }
      it { _(image).wont_be :video? }
      it { _(audio.kind).must_equal :audio }
      it { _(audio).wont_be :image? }
      it { _(audio).must_be :audio? }
      it { _(audio).wont_be :video? }
      it { _(video.kind).must_equal :video }
      it { _(video).wont_be :image? }
      it { _(video).wont_be :audio? }
      it { _(video).must_be :video? }
      it { _(doc.kind).must_equal :pdf }
      it { _(doc).wont_be :image? }
      it { _(doc).wont_be :audio? }
      it { _(doc).wont_be :video? }

      describe 'documents' do
        let(:asset) { PushType::Asset.new }
        it 'should detect modern word docs' do
          asset.mime_type = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
          asset.stub(:file_stored?, true) { _(asset.kind).must_equal :doc }
        end
        it 'should detect modern legacy word docs' do
          asset.mime_type = 'application/vnd.msword'
          asset.stub(:file_stored?, true) { _(asset.kind).must_equal :doc }
        end
        it 'should detect plain text files' do
          asset.mime_type = 'text/plain'
          asset.stub(:file_stored?, true) { _(asset.kind).must_equal :doc }
        end
        it 'should detect rich text files' do
          asset.mime_type = 'text/rtf'
          asset.stub(:file_stored?, true) { _(asset.kind).must_equal :doc }
        end
      end

      describe 'spreadsheets' do
        let(:asset) { PushType::Asset.new }
        it 'should detect modern excel docs' do
          asset.mime_type = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
          asset.stub(:file_stored?, true) { _(asset.kind).must_equal :sheet }
        end
        it 'should detect modern legacy excel docs' do
          asset.mime_type = 'application/vnd.ms-excel'
          asset.stub(:file_stored?, true) { _(asset.kind).must_equal :sheet }
        end
      end

      describe 'presentations' do
        let(:asset) { PushType::Asset.new }
        it 'should detect modern excel docs' do
          asset.mime_type = 'application/vnd.openxmlformats-officedocument.presentationml.presentation'
          asset.stub(:file_stored?, true) { _(asset.kind).must_equal :slides }
        end
        it 'should detect modern legacy excel docs' do
          asset.mime_type = 'application/vnd.ms-powerpoint'
          asset.stub(:file_stored?, true) { _(asset.kind).must_equal :slides }
        end
      end

      describe 'code' do
        let(:asset) { PushType::Asset.new }
        it 'should detect html' do
          asset.mime_type = 'text/html'
          asset.stub(:file_stored?, true) { _(asset.kind).must_equal :code }
        end
        it 'should detect javascript' do
          asset.mime_type = 'text/javascript'
          asset.stub(:file_stored?, true) { _(asset.kind).must_equal :code }
        end
        it 'should detect xml' do
          asset.mime_type = 'application/xml'
          asset.stub(:file_stored?, true) { _(asset.kind).must_equal :code }
        end
      end
    end

    describe '#description_or_file_name' do
      let(:asset) { FactoryBot.create :asset }
      it { _(asset.description_or_file_name).must_equal 'image.png' }
      it 'should return description when present' do
        asset.description = 'Foo bar'
        _(asset.description_or_file_name).must_equal 'Foo bar'
      end
    end

    describe '#media' do
      let(:image) { FactoryBot.create :image_asset }
      let(:doc)   { FactoryBot.create :document_asset }

      describe 'with no args' do
        it { _(image.media).must_equal image.file }
        it { _(doc.media).must_equal doc.file }
      end
      describe 'with original style' do
        it { _(image.media(:original)).must_equal image.file }
        it { _(doc.media(:original)).must_equal doc.file }
      end
      describe 'with a non existing style' do
        it { _(image.media(:foo_bar)).wont_equal image.file }
        it { expect { image.media(:foo_bar).width }.must_raise ArgumentError }
        it { _(doc.media(:foo_bar)).must_equal doc.file }
      end
      describe 'with a geometry string' do
        it { _(image.media('48x56#')).wont_equal image.file }
        it { _(image.media('48x56#').width).must_equal 48 }
        it { _(image.media('48x56#').height).must_equal 56 }
        it { _(image.media('48x56#')).must_be_kind_of Dragonfly::Job }
        it { _(doc.media('48x56#')).must_equal doc.file }
      end
    end

    describe '#preview_thumb' do
      let(:image) { FactoryBot.create :image_asset }
      let(:doc)   { FactoryBot.create :document_asset }
      it { _(image.preview_thumb).must_be_kind_of Dragonfly::Job }
      it { _(doc.preview_thumb).must_be_nil }
    end

    describe '#set_mime_type' do
      let(:asset) { FactoryBot.create :asset }
      it { _(asset.file_ext).must_equal 'png' }
      it { _(asset.mime_type).must_equal 'image/png' }
    end

  end
end
