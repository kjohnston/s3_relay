module S3Relay
  class PrivateUrl < S3Relay::Base

    attr_reader :expires, :path

    def initialize(uuid, file, options={})
      filename = Addressable::URI.escape(file).gsub("+", "%2B")
      @path    = [uuid, filename].join("/")
      @expires = (options[:expires] || 10.minutes.from_now).to_i
    end

    def generate
      "#{endpoint}/#{path}?#{params}"
    end

    private

    def params
      [
        "AWSAccessKeyId=#{access_key_id}",
        "Expires=#{expires}",
        "Signature=#{signature}"
      ].join("&")
    end

    def signature
      string = "GET\n\n\n#{expires}\n/#{bucket}/#{path}"
      hmac   = OpenSSL::HMAC.digest(digest, secret_access_key, string)
      CGI.escape(Base64.encode64(hmac).strip)
    end

  end
end
