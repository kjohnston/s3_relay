module S3Relay
  class UploadPresigner < S3Relay::Base

    attr_reader :expires, :uuid

    def initialize(options={})
      @expires = (options[:expires] || 1.minute.from_now).utc.xmlschema
      @uuid    = SecureRandom.uuid
    end

    def form_data
      fields.keys.inject({}) { |h,k| h[k.downcase.underscore] = fields[k]; h }
        .merge(
          "endpoint"  => endpoint,
          "policy"    => encoded_policy,
          "signature" => signature,
          "uuid"      => uuid
        )
    end

    private

    def fields
      {
        "AWSAccessKeyID"               => access_key_id,
        "x-amz-server-side-encryption" => "AES256",
        "key"                          => "#{uuid}/${filename}",
        "success_action_status"        => "201",
        "acl"                          => acl
      }
    end

    def hmac
      lambda { |data| OpenSSL::HMAC.digest(digest, secret_access_key, data) }
    end

    def policy_document
      {
        "expiration" => expires,
        "conditions" => [
          { "bucket" => bucket },
          { "acl" => acl },
          { "x-amz-server-side-encryption" => "AES256" },
          { "success_action_status" => "201" },
          ["starts-with", "$content-type", ""],
          ["starts-with", "$content-disposition", ""],
          ["starts-with", "$key", "#{uuid}/"]
        ]
      }
    end

    def encoded_policy
      Base64.strict_encode64(policy_document.to_json)
    end

    def signature
      Base64.strict_encode64(hmac[encoded_policy])
    end

  end
end
