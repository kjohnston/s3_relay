module S3Relay
  module UploadsHelper

    def s3_relay_field(parent_type, attribute, opts={})
      file_field       = file_field_tag(:file, opts.merge(class: "s3r-field"))
      progress_table   = content_tag(:table, "", class: "s3r-upload-list")
      content          = [file_field, progress_table].join
      data             = { parent_type: parent_type, attribute: attribute }
      data[:parent_id] = opts[:parent_id] if opts[:parent_id]

      content_tag(:div, raw(content),
        {
          class: "s3r-container",
          id:    "new-#{parent_type}-#{attribute}",
          data:  data
        }
      )
    end

  end
end
