module S3Relay
  class PrivateUrl < S3Relay::Base

    attr_reader :expires, :path

    def initialize(public_url, options={})
      @path    = URI.parse(public_url).path
      @expires = (options[:expires] || 10.minutes.from_now).to_i
    end

    def generate
      "#{endpoint}#{path}?#{params}"
    end

    private

    def params
      [
        "AWSAccessKeyId=#{ACCESS_KEY_ID}",
        "Expires=#{expires}",
        "Signature=#{signature}"
      ].join("&")
    end

    def signature
      string = "GET\n\n\n#{expires}\n/#{BUCKET}#{path}"
      hmac   = OpenSSL::HMAC.digest(digest, SECRET_ACCESS_KEY, string)
      CGI.escape(Base64.encode64(hmac).strip)
    end

  end
end
