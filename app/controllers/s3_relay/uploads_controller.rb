class S3Relay::UploadsController < ApplicationController

  def new
    render json: S3Relay::UploadPresigner.new.form_data
  end

  def create
    @upload = S3Relay::Upload.new(upload_attrs)

    if @upload.save
      render json: { private_url: @upload.private_url }, status: 201
    else
      render json: { errors: @upload.errors }, status: 422
    end
  end

  protected

  def parent_attrs
    parent_type = params[:parent_type]
    parent_id   = params[:parent_id]
    association = params[:association]

    begin
      public_send("#{parent_type.underscore.downcase}_#{association}_params")
    rescue
      { parent_type: parent_type, parent_id: parent_id }
    end
  end

  def upload_attrs
    {
      uuid:         params[:uuid],
      filename:     params[:filename],
      content_type: params[:content_type]
    }.merge(parent_attrs)
  end

end
