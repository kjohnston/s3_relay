require "test_helper"

describe S3Relay::Model do
  before do
    @product = FactoryBot.build(:product)
  end

  describe "#s3_relay" do

    describe "associations" do
      it "has_one" do
        _(Product.reflect_on_association(:icon_upload).macro)
          .must_equal(:has_one)
      end

      it "has_many" do
        _(Product.reflect_on_association(:photo_uploads).macro)
          .must_equal(:has_many)
      end
    end

    describe "scopes" do
      before do
        @product.save
        @icon    = FactoryBot.create(:icon_upload, parent: @product)
        @photo_1 = FactoryBot.create(:photo_upload, parent: @product)
        @photo_2 = FactoryBot.create(:photo_upload, parent: @product)
      end

      describe "has_one" do
        it { _(@product.icon_upload).must_equal @icon }
      end

      describe "has_many" do
        it do
          _(@product.photo_uploads.pluck(:id).sort)
            .must_equal [@photo_1.id, @photo_2.id]
        end
      end
    end

    describe "virtual attribute for UUID assignment" do
      it { _(@product).must_respond_to :new_photo_uploads_uuids= }
    end

    describe "association method" do
      before do
        @product = FactoryBot.create(:product)
        @icon    = FactoryBot.create(:icon_upload)
        @photo_1 = FactoryBot.create(:photo_upload)
        @photo_2 = FactoryBot.create(:photo_upload)
      end

      describe "has_many" do
        it do
          _(@product.photo_uploads).must_equal []
          @product.new_photo_uploads_uuids = [@photo_1.uuid, @photo_2.uuid]
          @product.associate_photo_uploads
          _(@product.photo_uploads).must_equal [@photo_1, @photo_2]
        end
      end
    end

  end

end
