require "test_helper"

describe S3Relay::UploadsHelper do
  before { @product = FactoryGirl.create(:product) }

  describe "#s3_relay_field" do
    it do
      s3_relay_field(@product, :photo_uploads, multiple: true)
        .must_equal %Q{<div class="s3r-container" data-association="photo_uploads" data-parent-id="#{@product.id}" data-parent-type="product"><input class="s3r-field" id="file" multiple="multiple" name="file" type="file" /><table class="s3r-upload-list"></table></div>}
    end
  end

end
