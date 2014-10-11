module S3Relay
  module UploadsHelper

    def s3_relay_field(parent, attribute, opts={})
      file_field     = file_field_tag(:file, opts.merge(class: "s3r-field"))
      progress_table = content_tag(:table, "", class: "s3r-upload-list")
      content        = [file_field, progress_table].join

      content_tag(:div, raw(content),
        {
          class: "s3r-container",
          id: "new-#{parent}-#{attribute}",
          data: { parent: parent, attribute: attribute }
        }
      )
    end

  end
end
