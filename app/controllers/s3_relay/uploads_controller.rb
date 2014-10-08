class S3Relay::UploadsController < ApplicationController

  def new
    render json: S3Relay::UploadPresigner.new.form_data
  end

  def create
    uuid        = params[:uuid]
    public_url  = params[:public_url]
    private_url = S3Relay::PrivateUrl.new(public_url).generate

    render json: { private_url: private_url }
  end

end
