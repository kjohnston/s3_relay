class S3Relay::UploadsController < ApplicationController

  def new
    render json: S3Relay::UploadPresigner.new.form_data
  end

  def create
    @upload = S3Relay::Upload.new(
      uuid:       params[:uuid],
      filename:   params[:filename],
      public_url: params[:public_url]
    )

    if @upload.save
      render json: { private_url: @upload.private_url }
    else
      render json: { errors: @upload.errors }
    end
  end

end
