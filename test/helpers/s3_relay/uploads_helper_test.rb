require "test_helper"

include ActionView::Helpers::FormTagHelper
include S3Relay::UploadsHelper

describe S3Relay::UploadsHelper do
  before { @product = FactoryBot.create(:product) }

  describe "#s3_relay_field" do
    describe "without options" do
      it do
        s3_relay_field(@product, :photo_uploads)
          .must_equal %Q{<div class="s3r-container" data-parent-type="product" data-parent-id="#{@product.id}" data-association="photo_uploads" data-disposition=\"inline\"><input type="file" name="file" id="file" class="s3r-field" /><table class="s3r-upload-list"></table></div>}
      end
    end

    describe "with multiple: true" do
      it do
        s3_relay_field(@product, :photo_uploads, multiple: true)
          .must_equal %Q{<div class="s3r-container" data-parent-type="product" data-parent-id="#{@product.id}" data-association="photo_uploads" data-disposition=\"inline\"><input type="file" name="file" id="file" multiple="multiple" class="s3r-field" /><table class="s3r-upload-list"></table></div>}
      end
    end

    describe "with disposition: attachment" do
      it do
        s3_relay_field(@product, :photo_uploads, disposition: :attachment)
          .must_equal %Q{<div class="s3r-container" data-parent-type="product" data-parent-id="#{@product.id}" data-association="photo_uploads" data-disposition=\"attachment\"><input type="file" name="file" id="file" disposition=\"attachment\" class="s3r-field" /><table class="s3r-upload-list"></table></div>}
      end
    end
  end

end
