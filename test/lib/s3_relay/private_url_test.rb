require "test_helper"

describe S3Relay::PrivateUrl do
  before do
    S3Relay::PrivateUrl.any_instance.stubs(:access_key_id)
      .returns("access-key-id")
    S3Relay::PrivateUrl.any_instance.stubs(:secret_access_key)
      .returns("secret-access-key")
    S3Relay::PrivateUrl.any_instance.stubs(:region)
      .returns("region")
    S3Relay::PrivateUrl.any_instance.stubs(:bucket)
      .returns("bucket")
    S3Relay::PrivateUrl.any_instance.stubs(:acl)
      .returns("acl")
  end

  describe "#generate" do
    it do
      uuid = "123-456-789"
      file = "Crazy + c@t picture.png"
      time = Time.parse("2014-01-01 12:00am")
      url  = S3Relay::PrivateUrl.new(uuid, file, expires: time).generate

      url.must_equal "https://bucket.s3-region.amazonaws.com/123-456-789/Crazy%20%2B%20c@t%20picture.png?AWSAccessKeyId=access-key-id&Expires=1388563200&Signature=8Kp5NL77iycg4CFFwxboo905t%2Fs%3D"
    end
  end

end
