class S3Relay::UploadsController < ApplicationController

  def new
    render json: S3Relay::UploadPresigner.new.form_data
  end

  def create
    # TODO
  end

end
