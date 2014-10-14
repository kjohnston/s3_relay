class S3Relay::UploadsController < ApplicationController

  def new
    render json: S3Relay::UploadPresigner.new.form_data
  end

  def create
    @upload = S3Relay::Upload.new(
      uuid:         params[:uuid],
      filename:     params[:filename],
      content_type: params[:content_type]
    )

    if @upload.save
      render json: { private_url: @upload.private_url }, status: 201
    else
      render json: { errors: @upload.errors }, status: 422
    end
  end

end
