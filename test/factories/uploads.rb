FactoryGirl.define do
  factory :upload, class: "S3Relay::Upload" do
    uuid         SecureRandom.uuid
    filename     "cat.png"
    content_type "image/png"
  end

  factory :icon_upload, parent: :upload do
    upload_type "IconUpload"
  end

  factory :photo_upload, parent: :upload do
    upload_type "PhotoUpload"
  end
end
