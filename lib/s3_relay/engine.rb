module S3Relay
  class Engine < ::Rails::Engine
    isolate_namespace S3Relay
  end
end

require "s3_relay/base"
require "s3_relay/private_url"
require "s3_relay/upload_presigner"
