@DcMercury.uploader = (file, options) ->
  DcMercury.uploader.show(file, options) if DcMercury.config.uploading.enabled
  return DcMercury.uploader

jQuery.extend DcMercury.uploader,

  show: (file, @options = {}) ->
    @file = new DcMercury.uploader.File(file)
    if @file.errors
      alert("Error: #{@file.errors}")
      return
    return unless @supported()

    DcMercury.trigger('focus:window')
    @initialize()
    @appear()


  initialize: ->
    return if @initialized
    @build()
    @bindEvents()
    @initialized = true


  supported: ->
    xhr = new XMLHttpRequest
    fileReader = window.FileReader

    if window.Uint8Array && window.ArrayBuffer && !XMLHttpRequest.prototype.sendAsBinary
      XMLHttpRequest::sendAsBinary = (datastr) ->
        ui8a = new Uint8Array(datastr.length)
        ui8a[index] = (datastr.charCodeAt(index) & 0xff) for data, index in datastr
        @send(ui8a.buffer)

    return !!(xhr.upload && xhr.sendAsBinary && fileReader)


  build: ->
    @element = jQuery('<div>', {class: 'dc_mercury-uploader', style: 'display:none'})
    @element.append('<div class="dc_mercury-uploader-preview"><b><img/></b></div>')
    @element.append('<div class="dc_mercury-uploader-details"></div>')
    @element.append('<div class="dc_mercury-uploader-progress"><span></span><div class="dc_mercury-uploader-indicator"><div><b>0%</b></div></div></div>')

    @updateStatus('Processing...')

    @overlay = jQuery('<div>', {class: 'dc_mercury-uploader-overlay', style: 'display:none'})

    @element.appendTo(jQuery(@options.appendTo).get(0) ? 'body')
    @overlay.appendTo(jQuery(@options.appendTo).get(0) ? 'body')


  bindEvents: ->
    DcMercury.on 'resize', => @position()


  appear: ->
    @fillDisplay()
    @position()

    @overlay.show()
    @overlay.animate {opacity: 1}, 200, 'easeInOutSine', =>
      @element.show()
      @element.animate {opacity: 1}, 200, 'easeInOutSine', =>
        @visible = true
        @loadImage()


  position: ->
    width = @element.outerWidth()
    height = @element.outerHeight()

    @element.css {
      top: (DcMercury.displayRect.height - height) / 2
      left: (DcMercury.displayRect.width - width) / 2
    }


  fillDisplay: ->
    details = [
      DcMercury.I18n('Name: %s', @file.name),
      DcMercury.I18n('Size: %s', @file.readableSize),
      DcMercury.I18n('Type: %s', @file.type)
    ]
    @element.find('.dc_mercury-uploader-details').html(details.join('<br/>'))


  loadImage: ->
    @file.readAsDataURL (result) =>
      @element.find('.dc_mercury-uploader-preview b').html(jQuery('<img>', {src: result}))
      @upload()


  upload: ->
    xhr = new XMLHttpRequest
    jQuery.each ['onloadstart', 'onprogress', 'onload', 'onabort', 'onerror'], (index, eventName) =>
      xhr.upload[eventName] = (event) => @uploaderEvents[eventName].call(@, event)
    xhr.onload = (event) =>
      if (event.currentTarget.status >= 400)
        @updateStatus('Error: Unable to upload the file')
        DcMercury.notify('Unable to process response: %s', event.currentTarget.status)
        @hide()
      else
        try
          response =
            if DcMercury.config.uploading.handler
              DcMercury.config.uploading.handler(event.target.responseText)
            else
              jQuery.parseJSON(event.target.responseText)
          src = response.url || response.image.url
          throw 'Malformed response from server.' unless src
          DcMercury.trigger('action', {action: 'insertImage', value: {src: src}})
          @hide()
        catch error
          @updateStatus('Error: Unable to upload the file')
          DcMercury.notify('Unable to process response: %s', error)
          @hide()

    xhr.open('post', DcMercury.config.uploading.url, true)
    xhr.setRequestHeader('Accept', 'application/json, text/javascript, text/html, application/xml, text/xml, */*')
    xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest')
    xhr.setRequestHeader(DcMercury.config.csrfHeader, DcMercury.csrfToken)

    @file.readAsBinaryString (result) =>
      # build the multipart post string
      multipart = new DcMercury.uploader.MultiPartPost(DcMercury.config.uploading.inputName, @file, result)

      # update the content size so we can calculate
      @file.updateSize(multipart.delta)

      # set the content type and send
      xhr.setRequestHeader('Content-Type', 'multipart/form-data; boundary=' + multipart.boundary)
      xhr.sendAsBinary(multipart.body)


  updateStatus: (message, loaded) ->
    @element.find('.dc_mercury-uploader-progress span').html(DcMercury.I18n(message).toString())
    if loaded
      percent = Math.floor(loaded * 100 / @file.size) + '%'
      @element.find('.dc_mercury-uploader-indicator div').css({width: percent})
      @element.find('.dc_mercury-uploader-indicator b').html(percent).show()


  hide: (delay = 0) ->
    setTimeout delay * 1000, =>
      @element.animate {opacity: 0}, 200, 'easeInOutSine', =>
        @overlay.animate {opacity: 0}, 200, 'easeInOutSine', =>
          @overlay.hide()
          @element.hide()
          @reset()
          @visible = false
          DcMercury.trigger('focus:frame')


  reset: ->
    @element.find('.dc_mercury-uploader-preview b').html('')
    @element.find('.dc_mercury-uploader-indicator div').css({width: 0})
    @element.find('.dc_mercury-uploader-indicator b').html('0%').hide()
    @updateStatus('Processing...')


  uploaderEvents:
    onloadstart: -> @updateStatus('Uploading...')

    onprogress: (event) -> @updateStatus('Uploading...', event.loaded)

    onabort: ->
      @updateStatus('Aborted')
      @hide(1)

    onload: ->
      @updateStatus('Successfully uploaded...', @file.size)

    onerror: ->
      @updateStatus('Error: Unable to upload the file')
      @hide(3)



class DcMercury.uploader.File

  constructor: (@file) ->
    @size = @file.size
    @fullSize = @file.size
    @readableSize = @file.size.toBytes()
    @name = @file.fileName
    @type = @file.type

    # add any errors if we need to
    errors = []
    errors.push(DcMercury.I18n('Too large')) if @size >= DcMercury.config.uploading.maxFileSize
    errors.push(DcMercury.I18n('Unsupported format')) unless DcMercury.config.uploading.allowedMimeTypes.indexOf(@type) > -1
    @errors = errors.join(' / ') if errors.length


  readAsDataURL: (callback = null) ->
    reader = new FileReader()
    reader.readAsDataURL(@file)
    reader.onload = => callback(reader.result) if callback


  readAsBinaryString: (callback = null) ->
    reader = new FileReader()
    reader.readAsBinaryString(@file)
    reader.onload = => callback(reader.result) if callback


  updateSize: (delta) ->
    @fullSize = @size + delta



class DcMercury.uploader.MultiPartPost

  constructor: (@inputName, @file, @contents, @formInputs = {}) ->
    @boundary = 'Boundaryx20072377098235644401115438165x'
    @body = ''
    @buildBody()
    @delta = @body.length - @file.size


  buildBody: ->
    boundary = '--' + @boundary
    for own name, value of @formInputs
      @body += "#{boundary}\r\nContent-Disposition: form-data; name=\"#{name}\"\r\n\r\n#{unescape(encodeURIComponent(value))}\r\n"
    @body += "#{boundary}\r\nContent-Disposition: form-data; name=\"#{@inputName}\"; filename=\"#{@file.name}\"\r\nContent-Type: #{@file.type}\r\nContent-Transfer-Encoding: binary\r\n\r\n#{@contents}\r\n#{boundary}--"
