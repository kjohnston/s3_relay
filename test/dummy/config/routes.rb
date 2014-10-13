Rails.application.routes.draw do
  mount S3Relay::Engine => "/s3_relay"
end
