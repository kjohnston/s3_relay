require "test_helper"

describe S3Relay::UploadPresigner do
  before do
    S3Relay::UploadPresigner.any_instance.stubs(:access_key_id)
      .returns("access-key-id")
    S3Relay::UploadPresigner.any_instance.stubs(:secret_access_key)
      .returns("secret-access-key")
    S3Relay::UploadPresigner.any_instance.stubs(:region)
      .returns("region")
    S3Relay::UploadPresigner.any_instance.stubs(:bucket)
      .returns("bucket")
    S3Relay::UploadPresigner.any_instance.stubs(:acl)
      .returns("acl")
  end

  describe "#form_data" do
    it do
      uuid = SecureRandom.uuid
      time = Time.parse("2014-12-01 12:00am")

      S3Relay::UploadPresigner.any_instance.stubs(:uuid).returns(uuid)

      data = S3Relay::UploadPresigner.new(expires: time).form_data

      data["awsaccesskeyid"].must_equal "access-key-id"
      data["x_amz_server_side_encryption"].must_equal "AES256"
      data["key"].must_equal "#{uuid}/${filename}"
      data["success_action_status"].must_equal "201"
      data["acl"].must_equal "acl"
      data["endpoint"].must_equal "https://bucket.s3-region.amazonaws.com"
      data["policy"].length.must_equal 400  # TODO: Improve this
      data["signature"].length.must_equal 28  # TODO: Improve this
      data["uuid"].must_equal uuid
    end
  end

end
