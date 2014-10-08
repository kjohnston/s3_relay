S3Relay::Engine.routes.draw do

  resources :uploads, only: [:new, :create]

end
