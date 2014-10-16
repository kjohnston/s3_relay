module S3Relay
  module Model

    def s3_relay(attribute, has_many=false)

      virtual_attribute = "new_#{attribute}_uuids"

      attr_accessor virtual_attribute

      if has_many
        has_many attribute, as: :parent, class_name: "S3Relay::Upload"

        define_method attribute do
          S3Relay::Upload.where(parent_type: self.class.to_s, parent_id: self.id)
        end
      else
        has_one attribute, as: :parent, class_name: "S3Relay::Upload"

        define_method attribute do
          S3Relay::Upload.where(parent_type: self.class.to_s, parent_id: self.id).order("uploaded_at DESC").limit(1)
        end
      end

      association_method = "associate_#{attribute}"

      after_save "associate_#{attribute}"

      define_method association_method do
        S3Relay::Upload.where(uuid: send(virtual_attribute))
          .update_all(parent_type: self.class.to_s, parent_id: self.id)
      end

    end

  end

end
