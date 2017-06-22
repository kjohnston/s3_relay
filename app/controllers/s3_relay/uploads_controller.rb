class S3Relay::UploadsController < ApplicationController

  before_action :authenticate
  skip_before_action :verify_authenticity_token

  def new
    render json: S3Relay::UploadPresigner.new.form_data
  end

  def create
    @upload = S3Relay::Upload.new(upload_attrs)

    if @upload.save
      data = {
        private_url: @upload.private_url,
        parent_type: @upload.parent_type,
        parent_id: @upload.parent_id,
        user_id: user_attrs[:user_id]
      }
      render json: data, status: 201
    else
      render json: { errors: @upload.errors }, status: 422
    end
  end

  protected

  def authenticate
    if respond_to?(:authenticate_for_s3_relay)
      authenticate_for_s3_relay
    end
  end

  def parent_attrs
    type = params[:parent_type].try(:classify)
    id   = params[:parent_id]

    return {} unless type.present? && id.present? &&
      parent = type.constantize.find_by_id(id)

    begin
      public_send(
        "#{type.underscore.downcase}_#{params[:association]}_params",
        parent
      )
    rescue NoMethodError
      { parent: parent }
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
    if respond_to?(:current_user) && (id = current_user&.id)
      { user_id: id }
    else
      {}
    end
  end

end
