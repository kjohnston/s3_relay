Rails.application.routes.draw do
  mount S3Relay::Engine => "/s3_relay"

  namespace :s3_relay do
    resources :uploads, only: [:new, :create]
  end
end
