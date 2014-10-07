uploadFile = (fileField) ->
  form = fileField.parent()
  fileInput = document.getElementById("file")
  file = fileInput.files[0]

  $.ajax
    type: "GET"
    url: "/signatures/new"
    success: (response) ->
      formData = new FormData()
      xhr = new XMLHttpRequest()
      endpoint = response.endpoint

      formData.append("AWSAccessKeyID", response.awsaccesskeyid)
      formData.append("x-amz-server-side-encryption", response.x_amz_server_side_encryption)
      formData.append("key", response.key)
      formData.append("success_action_status", response.success_action_status)
      formData.append("acl", response.acl)
      formData.append("policy", response.policy)
      formData.append("signature", response.signature)
      formData.append("file", file)

      fileField.val("")

      uuid = response.uuid
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

            url = $("Location", xhr.responseXML).text()
            # TODO: Pass URL to app, retrieve private URL and display link
          else
            progressBar.text("File could not be uploaded")
            console.log $("Message", xhr.responseXML).text()

      xhr.open "POST", endpoint, true
      xhr.send formData

jQuery ->

  $("form.s3_relay").on "change", "input[type='file']", ->
    uploadFile($(this))
