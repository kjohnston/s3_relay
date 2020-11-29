FactoryBot.define do
  factory :upload, class: "S3Relay::Upload" do
    uuid { SecureRandom.uuid }
  end

  factory :file_upload, parent: :upload do
    filename     { "cat.png" }
    content_type { "image/png" }
    upload_type  { "FileUpload" }
  end

  factory :icon_upload, parent: :upload do
    filename     { "cat.png" }
    content_type { "image/png" }
    upload_type  { "IconUpload" }
  end

  factory :photo_upload, parent: :upload do
    filename     { "cat.png" }
    content_type { "image/png" }
    upload_type  { "PhotoUpload" }
  end
end
