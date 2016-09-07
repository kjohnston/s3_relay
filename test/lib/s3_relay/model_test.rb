require "test_helper"

describe S3Relay::Model do
  before do
    @product = FactoryGirl.build(:product)
  end

  describe "#s3_relay" do

    describe "associations" do
      it "has_one" do
        Product.reflect_on_association(:icon_upload).macro
          .must_equal(:has_one)
      end

      it "has_many" do
        Product.reflect_on_association(:photo_uploads).macro
          .must_equal(:has_many)
      end
    end

    describe "scopes" do
      before do
        @product.save
        @icon    = FactoryGirl.create(:icon_upload, parent: @product)
        @photo_1 = FactoryGirl.create(:photo_upload, parent: @product)
        @photo_2 = FactoryGirl.create(:photo_upload, parent: @product)
      end

      describe "has_one" do
        it { @product.icon_upload.must_equal @icon }
      end

      describe "has_many" do
        it do
          @product.photo_uploads.pluck(:id).sort
            .must_equal [@photo_1.id, @photo_2.id]
        end
      end
    end

    describe "virtual attribute for UUID assignment" do
      it { @product.must_respond_to :new_photo_uploads_uuids= }
    end

    describe "association method" do
      before do
        @product = FactoryGirl.create(:product)
        @icon    = FactoryGirl.create(:icon_upload)
        @photo_1 = FactoryGirl.create(:photo_upload)
        @photo_2 = FactoryGirl.create(:photo_upload)
      end

      describe "has_many" do
        it do
          @product.photo_uploads.must_equal []
          @product.new_photo_uploads_uuids = [@photo_1.uuid, @photo_2.uuid]
          @product.associate_photo_uploads
          @product.photo_uploads.must_equal [@photo_1, @photo_2]
        end
      end
    end

  end

end
