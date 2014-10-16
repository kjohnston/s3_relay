S3Relay::Engine.routes.draw do

  resources :uploads, only: [:new, :create] do
    post :associate, on: :collection
  end

end
