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
    type = params[:parent_type].try(:classify)
    id   = params[:parent_id]

    return {} unless type.present? && id.present? &&
      type.constantize.find_by_id(id)

    begin
      public_send("#{type.underscore.downcase}_#{params[:association]}_params")
    rescue NoMethodError
      { parent_type: type, parent_id: id }
    end
  end

  def upload_attrs
    attrs = {
      upload_type:  params[:association].try(:classify),
      uuid:         params[:uuid],
      filename:     params[:filename],
      content_type: params[:content_type]
    }

    attrs.merge!(parent_attrs)
    attrs.merge!(user_attrs)
  end

  def user_attrs
    respond_to?(:current_user) ? { user_id: current_user.id } : {}
  end

end
