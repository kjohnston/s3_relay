module S3Relay
  class Base

    ACCESS_KEY_ID     = ENV["S3_RELAY_ACCESS_KEY_ID"]
    SECRET_ACCESS_KEY = ENV["S3_RELAY_SECRET_ACCESS_KEY"]
    REGION            = ENV["S3_RELAY_REGION"]
    BUCKET            = ENV["S3_RELAY_BUCKET"]
    ACL               = ENV["S3_RELAY_ACL"]

    private

    def endpoint
      "https://#{BUCKET}.s3-#{REGION}.amazonaws.com"
    end

    def digest
      OpenSSL::Digest.new("sha1")
    end

  end
end
