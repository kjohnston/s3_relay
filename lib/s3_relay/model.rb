module S3Relay
  module Model

    def s3_relay(attribute, has_many=false)
      upload_type = attribute.to_s.classify

      if has_many
        has_many attribute, as: :parent, class_name: "S3Relay::Upload"

        define_method attribute do
          S3Relay::Upload
            .where(
              parent_type: self.class.to_s,
              parent_id:   self.id,
              upload_type: upload_type
            )
        end
      else
        has_one attribute, as: :parent, class_name: "S3Relay::Upload"

        define_method attribute do
          S3Relay::Upload
            .where(
              parent_type: self.class.to_s,
              parent_id:   self.id,
              upload_type: upload_type
            )
            .order("pending_at DESC").last
        end
      end

      virtual_attribute = "new_#{attribute}_uuids"
      attr_accessor virtual_attribute

      association_method = "associate_#{attribute}"

      after_save association_method.to_sym

      define_method association_method do
        new_uuids = send(virtual_attribute)
        return if new_uuids.blank?

        S3Relay::Upload.where(uuid: new_uuids, upload_type: upload_type)
          .update_all(parent_type: self.class.to_s, parent_id: self.id)
      end

    end

  end

end
