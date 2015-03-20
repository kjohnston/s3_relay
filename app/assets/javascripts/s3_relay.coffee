displayFailedUpload = (progressColumn=null) ->
  if progressColumn
    progressColumn.text("File could not be uploaded")
  else
    alert("File could not be uploaded")

publishEvent = (name, detail) ->
  ev = document.createEvent "CustomEvent"
  ev.initCustomEvent name, true, false, detail
  document.dispatchEvent ev

saveUrl = (container, uuid, filename, contentType, publicUrl) ->
  privateUrl = null

  $.ajax
    type: "POST"
    url: "/s3_relay/uploads"
    async: false
    data:
      parent_type: container.data("parentType")
      parent_id: container.data("parentId")
      association: container.data("association")
      uuid: uuid
      filename: filename
      content_type: contentType
      public_url: publicUrl
    success: (data, status, xhr) ->
      privateUrl = data.private_url
      publishEvent "upload:success", "detail"
    error: (xhr) ->
      console.log xhr.responseText

  return privateUrl

uploadFiles = (container) ->
  fileInput = $("input.s3r-field", container)
  files = fileInput.get(0).files
  uploadFile(container, file) for file in files
  fileInput.val("")

uploadFile = (container, file) ->
  fileName = file.name

  $.ajax
    type: "GET"
    url: "/s3_relay/uploads/new"
    async: false
    success: (data, status, xhr) ->
      formData = new FormData()
      xhr = new XMLHttpRequest()
      endpoint = data.endpoint
      disposition = container.data("disposition")

      formData.append("AWSAccessKeyID", data.awsaccesskeyid)
      formData.append("x-amz-server-side-encryption", data.x_amz_server_side_encryption)
      formData.append("key", data.key)
      formData.append("success_action_status", data.success_action_status)
      formData.append("acl", data.acl)
      formData.append("policy", data.policy)
      formData.append("signature", data.signature)
      formData.append("content-type", file.type)
      formData.append("content-disposition", "#{disposition}; filename=\"#{fileName}\"")
      formData.append("file", file)

      uuid = data.uuid

      uploadList = $(".s3r-upload-list", container)
      uploadList.prepend("<tr id='#{uuid}'><td><div class='s3r-file-url'>#{fileName}</div></td><td class='s3r-progress'><div class='s3r-bar' style='display: none;'><div class='s3r-meter'></div></div></td></tr>")
      fileColumn = $(".s3r-upload-list ##{uuid} .s3r-file-url", container)
      progressColumn = $(".s3r-upload-list ##{uuid} .s3r-progress", container)
      progressBar = $(".s3r-bar", progressColumn)
      progressMeter = $(".s3r-meter", progressColumn)

      xhr.upload.addEventListener "progress", (ev) ->
        if ev.position
          percentage = ((ev.position / ev.totalSize) * 100.0).toFixed(0)
          progressBar.show()
          progressMeter.css "width", "#{percentage}%"
        else
          progressColumn.text("Uploading...")  # IE can't get position

      xhr.onreadystatechange = (ev) ->
        if xhr.readyState is 4
          progressColumn.text("")  # IE can't get position
          progressBar.remove()

          if xhr.status == 201
            contentType = file.type
            publicUrl = $("Location", xhr.responseXML).text()
            privateUrl = saveUrl(container, uuid, fileName, contentType, publicUrl)

            if privateUrl == null
              displayFailedUpload(progressColumn)
            else
              fileColumn.html("<a href='#{privateUrl}'>#{fileName}</a>")

              virtualAttr = "#{container.data('parentType')}[new_#{container.data('association')}_uuids]"
              hiddenField = "<input type='hidden' name='#{virtualAttr}[]' value='#{uuid}' />"
              container.append(hiddenField)

          else
            displayFailedUpload(progressColumn)
            console.log $("Message", xhr.responseXML).text()

      xhr.open "POST", endpoint, true
      xhr.send formData
    error: (xhr) ->
      displayFailedUpload()
      console.log xhr.responseText

jQuery ->

  $(document).on "change", ".s3r-field", ->
    $this = $(this)

    if !!window.FormData
      uploadFiles($this.parent())
    else
      $this.hide()
      $this.parent().append("<p>Your browser can't handle file uploads, please switch to <a href='http://google.com/chrome'>Google Chrome</a>.</p>")
