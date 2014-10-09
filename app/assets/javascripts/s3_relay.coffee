saveUrl = (uuid, filename, public_url) ->
  private_url = null

  $.ajax
    type: "POST"
    url: "/s3_relay/uploads"
    async: false
    data:
      uuid: uuid
      filename: filename
      public_url: public_url
    success: (data, status, xhr) ->
      private_url = data.private_url
    error: (response) ->
      # TODO: Handle errors
      alert response

  return private_url

uploadFiles = (form) ->
  fileInput = $("input[type='file']", form)
  files = fileInput.get(0).files

  for file in files
    uploadFile(form, file)

  fileInput.val("")

uploadFile = (form, file) ->
  fileName = file.name

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

      uuid = data.uuid

      uploadList = $(".upload-list", form)
      unless uploadList.length > 0
        form.append("<table class='upload-list'></table>")
        uploadList = $(".upload-list", form)

      uploadList.append("<tr id='#{uuid}'><td class='file-url'>#{fileName}</td><td class='progress'><div class='bar'><div class='meter'></div></div></td></tr>")
      fileColumn = $(".upload-list ##{uuid} .file-url", form)
      progressBar = $(".upload-list ##{uuid} .bar", form)
      progressMeter = $(".upload-list ##{uuid} .meter", form)

      xhr.upload.addEventListener "progress", (ev) ->
        percentage = ((ev.position / ev.totalSize) * 100.0).toFixed(0)
        progressMeter.css "width", "#{percentage}%"

      xhr.onreadystatechange = (ev) ->
        if xhr.readyState is 4
          if xhr.status == 201
            publicUrl = $("Location", xhr.responseXML).text()
            privateUrl = saveUrl(uuid, fileName, publicUrl)
            link = "<a href='#{privateUrl}'>#{fileName}</a>"

            fileColumn.html(link)
            progressBar.remove()
          else
            alert "File could not be uploaded"
            console.log $("Message", xhr.responseXML).text()

      xhr.open "POST", endpoint, true
      xhr.send formData
    error: (response) ->
      # TODO: Handle errors
      alert response

jQuery ->

  $("form.s3_relay").on "change", "input[type='file']", ->
    uploadFiles($(this).parent("form"))
