saveUrl = (uuid, public_url) ->
  private_url = null

  $.ajax
    type: "POST"
    url: "/s3_relay/uploads"
    async: false
    data:
      uuid: uuid
      public_url: public_url
    success: (data, status, xhr) ->
      private_url = data.private_url
    error: (response) ->
      console.log response

  return private_url

uploadFile = (fileField) ->
  form = fileField.parent()
  fileInput = document.getElementById("file")
  file = fileInput.files[0]

  $.ajax
    type: "GET"
    url: "/s3_relay/uploads/new"
    success: (data, status, xhr) ->
      formData = new FormData()
      xhr = new XMLHttpRequest()
      endpoint = data.endpoint

      formData.append("AWSAccessKeyID", data.awsaccesskeyid)
      formData.append("x-amz-server-side-encryption", data.x_amz_server_side_encryption)
      formData.append("key", data.key)
      formData.append("success_action_status", data.success_action_status)
      formData.append("acl", data.acl)
      formData.append("policy", data.policy)
      formData.append("signature", data.signature)
      formData.append("file", file)

      fileField.val("")

      uuid = data.uuid
      form.append("<div id='progress-#{uuid}'></div>")
      progressBar = $("#progress-#{uuid}")

      xhr.upload.addEventListener "progress", (ev) ->
        # Progress...
        percentage = ((ev.position / ev.totalSize) * 100.0).toFixed(2) + "%"
        progressBar.text("Uploading: #{file.name} - " + percentage)

      xhr.onreadystatechange = (ev) ->
        if xhr.readyState is 4
          if xhr.status == 201
            progressBar.text("Uploading: #{file.name} - Complete")

            public_url = $("Location", xhr.responseXML).text()
            private_url = saveUrl(uuid, public_url)
            link = "<a href='#{private_url}'>#{file.name}</a>"

            progressBar.html(link)
          else
            progressBar.text("File could not be uploaded")
            console.log $("Message", xhr.responseXML).text()

      xhr.open "POST", endpoint, true
      xhr.send formData
    error: (response) ->
      console.log response

jQuery ->

  $("form.s3_relay").on "change", "input[type='file']", ->
    uploadFile($(this))
