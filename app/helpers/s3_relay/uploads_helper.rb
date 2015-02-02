module S3Relay
  module UploadsHelper

    def s3_relay_field(parent, association, opts={})
      file_field     = file_field_tag(:file, opts.merge(class: "s3r-field"))
      progress_table = content_tag(:table, "", class: "s3r-upload-list")
      content        = [file_field, progress_table].join
      parent_type    = parent.class.to_s.underscore.downcase

      content_tag(:div, raw(content),
        {
          class: "s3r-container",
          data:  {
            parent_type: parent_type,
            parent_id:   parent.id.to_s,
            association: association.to_s,
            disposition: opts.fetch(:disposition, "inline")
          }
        }
      )
    end

  end
end
