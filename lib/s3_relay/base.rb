module S3Relay
  class Base

    private

    def access_key_id
      ENV["S3_RELAY_ACCESS_KEY_ID"]
    end

    def secret_access_key
      ENV["S3_RELAY_SECRET_ACCESS_KEY"]
    end

    def region
      ENV["S3_RELAY_REGION"]
    end

    def bucket
      ENV["S3_RELAY_BUCKET"]
    end

    def acl
      ENV["S3_RELAY_ACL"]
    end

    def endpoint
      "https://#{bucket}.s3-#{region}.amazonaws.com"
    end

    def digest
      OpenSSL::Digest.new("sha1")
    end

  end
end
