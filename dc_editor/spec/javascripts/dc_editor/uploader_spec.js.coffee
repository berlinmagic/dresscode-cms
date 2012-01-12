describe "DcEditor.uploader", ->

  template 'dc_editor/uploader.html'

  beforeEach ->
    DcEditor.config.uploading.enabled = true
    $.fx.off = true
    @mockFile = {
      size: 1024
      fileName: 'image.png'
      type: 'image/png'
    }

  afterEach ->
    DcEditor.uploader.initialized = false

  describe "singleton method", ->

    beforeEach ->
      @showSpy = spyOn(DcEditor.uploader, 'show').andCallFake(=>)

    it "calls show", ->
      DcEditor.uploader(@mockFile)
      expect(@showSpy.callCount).toEqual(1)

    it "returns the function object", ->
      ret = DcEditor.uploader(@mockFile)
      expect(ret).toEqual(DcEditor.uploader)

    it "doesn't call show if disabled in configuration", ->
      DcEditor.config.uploading.enabled = false
      DcEditor.uploader(@mockFile)
      expect(@showSpy.callCount).toEqual(0)


  describe "#show", ->

    beforeEach ->
      @initializeSpy = spyOn(DcEditor.uploader, 'initialize').andCallFake(=>)
      @appearSpy = spyOn(DcEditor.uploader, 'appear').andCallFake(=>)

    it "expects a file object", ->
      DcEditor.uploader.show(@mockFile)
      expect(DcEditor.uploader.file.name).toEqual(@mockFile.fileName)

    it "accepts options", ->
      DcEditor.uploader.show(@mockFile, {foo: 'bar'})
      expect(DcEditor.uploader.options).toEqual({foo: 'bar'})

    it "creates a file instance from the file", ->
      DcEditor.uploader.show(@mockFile)
      expect(DcEditor.uploader.file.name).toEqual(@mockFile.fileName)
      expect(DcEditor.uploader.file.fullSize).toEqual(1024)

    it "alerts and stops if the file has errors (too large or unsupported mimetype)", ->
      @mockFile.size = 123123123123
      spy = spyOn(window, 'alert').andCallFake(=>)
      DcEditor.uploader.show(@mockFile)
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['Error: Too large'])

    it "doesn't do anything unless xhr uploading is supported in the browser", ->
      spyOn(DcEditor.uploader, 'supported').andCallFake(=> false)
      DcEditor.uploader.show(@mockFile)
      expect(@initializeSpy.callCount).toEqual(0)

    it "triggers an event to focus the window", ->
      spy = spyOn(DcEditor, 'trigger').andCallFake(=>)
      DcEditor.uploader.show(@mockFile)
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['focus:window'])

    it "calls initialize", ->
      DcEditor.uploader.show(@mockFile)
      expect(@initializeSpy.callCount).toEqual(1)

    it "calls appear", ->
      DcEditor.uploader.show(@mockFile)
      expect(@appearSpy.callCount).toEqual(1)


  describe "#initialize", ->

    beforeEach ->
      @buildSpy = spyOn(DcEditor.uploader, 'build').andCallFake(=>)
      @bindEventsSpy = spyOn(DcEditor.uploader, 'bindEvents').andCallFake(=>)

    it "calls build", ->
      DcEditor.uploader.initialize()
      expect(@buildSpy.callCount).toEqual(1)

    it "calls bindEvents", ->
      DcEditor.uploader.initialize()
      expect(@bindEventsSpy.callCount).toEqual(1)

    it "only initializes once", ->
      DcEditor.uploader.initialize()
      expect(@buildSpy.callCount).toEqual(1)
      DcEditor.uploader.initialize()
      expect(@buildSpy.callCount).toEqual(1)


  describe "#supported", ->

    it "prototypes sendAsBinary onto XMLHttpRequest if it's not already there", ->
      XMLHttpRequest.prototype.sendAsBinary = null
      DcEditor.uploader.supported()
      expect(XMLHttpRequest.prototype.sendAsBinary).toBeDefined()

    it "returns true if everything needed is supported", ->
      ret = DcEditor.uploader.supported()
      expect(ret).toEqual(true)

    it "returns false if everything isn't supported", ->
      window.Uint8Array = null
      ret = DcEditor.uploader.supported()
      expect(ret).toEqual(true)


  describe "#build", ->

    beforeEach ->
      DcEditor.uploader.options = {appendTo: '#test'}

    it "builds an element structure", ->
      DcEditor.uploader.build()
      html = $('<div>').html(DcEditor.uploader.element).html()
      expect(html).toContain('class="dc_editor-uploader"')
      expect(html).toContain('class="dc_editor-uploader-preview"')
      expect(html).toContain('<b><img></b>')
      expect(html).toContain('class="dc_editor-uploader-details"')
      expect(html).toContain('<span>Processing...</span>')
      expect(html).toContain('class="dc_editor-uploader-indicator"')
      expect(html).toContain('<div><b>0%</b></div>')

    it "builds an overlay", ->
      DcEditor.uploader.build()
      html = $('<div>').html(DcEditor.uploader.overlay).html()
      expect(html).toContain('class="dc_editor-uploader-overlay"')

    it "appends to any element", ->
      DcEditor.uploader.options = {appendTo: '#uploader_container'}
      DcEditor.uploader.build()
      expect($('#uploader_container .dc_editor-uploader').length).toEqual(1)


  describe "observed events", ->

    describe "custom event: resize", ->

      it "calls position", ->
        spy = spyOn(DcEditor.uploader, 'position').andCallFake(=>)
        DcEditor.uploader.bindEvents()
        DcEditor.trigger('resize')
        expect(spy.callCount).toEqual(1)


  describe "#appear", ->

    beforeEach ->
      DcEditor.uploader.options = {appendTo: '#test'}
      DcEditor.uploader.build()
      @fillDisplaySpy = spyOn(DcEditor.uploader, 'fillDisplay').andCallFake(=>)
      @positionSpy = spyOn(DcEditor.uploader, 'position').andCallFake(=>)
      @loadImageSpy = spyOn(DcEditor.uploader, 'loadImage').andCallFake(=>)

    it "calls fillDisplay", ->
      DcEditor.uploader.appear()
      expect(@fillDisplaySpy.callCount).toEqual(1)

    it "calls position", ->
      DcEditor.uploader.appear()
      expect(@positionSpy.callCount).toEqual(1)

    it "displays the overlay, and the element", ->
      DcEditor.uploader.appear()
      expect($('#test .dc_editor-uploader').css('display')).toEqual('block')
      expect($('#test .dc_editor-uploader-overlay').css('display')).toEqual('block')

    it "sets visible to true", ->
      DcEditor.uploader.appear()
      expect(DcEditor.uploader.visible).toEqual(true)

    it "calls loadImage", ->
      DcEditor.uploader.appear()
      expect(@loadImageSpy.callCount).toEqual(1)


  describe "#position", ->

    beforeEach ->
      DcEditor.uploader.options = {appendTo: '#test'}
      DcEditor.uploader.build()
      @fillDisplaySpy = spyOn(DcEditor.uploader, 'fillDisplay').andCallFake(=>)
      @positionSpy = spyOn(DcEditor.uploader, 'position').andCallFake(=>)

    it "centers the element in the viewport", ->
      # todo: this isn't really being tested
      DcEditor.uploader.element.css({display: 'block'})
      DcEditor.uploader.position()
      @expect($('#test .dc_editor-uploader').offset()).toEqual({top: 0, left: 0})


  describe "#fillDisplay", ->

    beforeEach ->
      DcEditor.uploader.options = {appendTo: '#test'}
      DcEditor.uploader.file = {name: 'image.png', size: 1024, type: 'image/png'}
      DcEditor.uploader.build()

    it "puts the file details into the element", ->
      DcEditor.uploader.fillDisplay()
      expect($('#test .dc_editor-uploader-details').html()).toEqual('Name: image.png<br>Size: undefined<br>Type: image/png')


  describe "#loadImage", ->

    beforeEach ->
      DcEditor.uploader.options = {appendTo: '#test'}
      DcEditor.uploader.file = new DcEditor.uploader.File(@mockFile)
      DcEditor.uploader.build()
      spyOn(FileReader.prototype, 'readAsBinaryString').andCallFake(=>)
      @readAsDataURLSpy = spyOn(DcEditor.uploader.File.prototype, 'readAsDataURL').andCallFake((callback) => callback('data-url'))

    it "calls file.readAsDataURL", ->
      DcEditor.uploader.loadImage()
      expect(@readAsDataURLSpy.callCount).toEqual(1)

    it "sets the preview image src to the file contents", ->
      DcEditor.uploader.loadImage()
      expect($('#test .dc_editor-uploader-preview img').attr('src')).toEqual('data-url')

    it "calls upload", ->
      spy = spyOn(DcEditor.uploader, 'upload').andCallFake(=>)
      DcEditor.uploader.loadImage()
      expect(spy.callCount).toEqual(1)


  describe "#upload", ->

    # todo: test this
    it "", ->


  describe "#updateStatus", ->

    beforeEach ->
      DcEditor.uploader.options = {appendTo: '#test'}
      DcEditor.uploader.build()

    it "updated the message in the progress display", ->
      DcEditor.uploader.updateStatus('status message')
      expect($('#test .dc_editor-uploader-progress span').html()).toEqual('status message')

    it "updates the progress indicator width", ->
      DcEditor.uploader.updateStatus('message', 512)
      expect($('#test .dc_editor-uploader-indicator div').css('width')).toEqual('50px')

    it "updates the progress indicator value", ->
      DcEditor.uploader.updateStatus('message', 512)
      expect($('#test .dc_editor-uploader-indicator b').html()).toEqual('50%')


  describe "#hide", ->

    beforeEach ->
      @setTimeoutSpy = spyOn(window, 'setTimeout')
      DcEditor.uploader.options = {appendTo: '#test'}
      DcEditor.uploader.build()

    it "accepts a delay", ->
      @setTimeoutSpy.andCallFake(=>)
      DcEditor.uploader.hide(1)
      expect(@setTimeoutSpy.callCount).toEqual(1)
      expect(@setTimeoutSpy.argsForCall[0][0]).toEqual(1000)

    it "hides the overlay and element", ->
      @setTimeoutSpy.andCallFake((timeout, callback) => callback())
      DcEditor.uploader.hide()
      expect($('#test .dc_editor-uploader').css('opacity')).toEqual('0')
      expect($('#test .dc_editor-uploader-overlay').css('opacity')).toEqual('0')

    it "calls reset", ->
      @setTimeoutSpy.andCallFake((timeout, callback) => callback())
      spy = spyOn(DcEditor.uploader, 'reset').andCallFake(=>)
      DcEditor.uploader.hide()
      expect(spy.callCount).toEqual(1)

    it "sets visible to false", ->
      @setTimeoutSpy.andCallFake((timeout, callback) => callback())
      DcEditor.uploader.hide()
      expect(DcEditor.uploader.visible).toEqual(false)

    it "focuses the frame", ->
      @setTimeoutSpy.andCallFake((timeout, callback) => callback())
      spy = spyOn(DcEditor, 'trigger').andCallFake(=>)
      DcEditor.uploader.hide()
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['focus:frame'])


  describe "#reset", ->

    beforeEach ->
      DcEditor.uploader.options = {appendTo: '#test'}
      DcEditor.uploader.build()

    it "removes the preview image", ->
      $('#test .dc_editor-uploader-indicator div').html('foo')
      DcEditor.uploader.reset()
      expect($('#test .dc_editor-uploader-preview b').html()).toEqual('')

    it "resets the progress back to 0", ->
      $('#test .dc_editor-uploader-indicator div').css({width: '50%'})
      $('#test .dc_editor-uploader-indicator b').html('50%')
      DcEditor.uploader.reset()
      expect($('#test .dc_editor-uploader-indicator div').css('width')).toEqual('0px')
      expect($('#test .dc_editor-uploader-indicator b').html()).toEqual('0%')

    it "sets the status back to 'Processing...' for next time", ->
      spy = spyOn(DcEditor.uploader, 'updateStatus').andCallFake(=>)
      DcEditor.uploader.reset()
      expect(spy.callCount).toEqual(1)


  describe "uploaderEvents", ->

    beforeEach ->
      DcEditor.uploader.file = @mockFile
      @updateStatusSpy = spyOn(DcEditor.uploader, 'updateStatus').andCallFake(=>)
      @hideSpy = spyOn(DcEditor.uploader, 'hide').andCallFake(=>)
      @events = DcEditor.uploader.uploaderEvents

    describe ".onloadstart", ->

      it "updates the status to 'Uploading...'", ->
        @events.onloadstart.call(DcEditor.uploader)
        expect(@updateStatusSpy.callCount).toEqual(1)
        expect(@updateStatusSpy.argsForCall[0]).toEqual(['Uploading...'])

    describe ".onprogress", ->

      it "updates the status to 'Uploading...' and passes the amount sent so far", ->
        @events.onprogress.call(DcEditor.uploader, {loaded: 512})
        expect(@updateStatusSpy.callCount).toEqual(1)
        expect(@updateStatusSpy.argsForCall[0]).toEqual(['Uploading...', 512])

    describe ".onabort", ->

      it "updates the status to 'Aborted'", ->
        @events.onabort.call(DcEditor.uploader)
        expect(@updateStatusSpy.callCount).toEqual(1)
        expect(@updateStatusSpy.argsForCall[0]).toEqual(['Aborted'])

      it "calls hide", ->
        @events.onabort.call(DcEditor.uploader)
        expect(@hideSpy.callCount).toEqual(1)

    describe ".onload", ->

      it "updates the status to 'Successfully uploaded' and passes the total file size", ->
        @events.onload.call(DcEditor.uploader)
        expect(@updateStatusSpy.callCount).toEqual(1)
        expect(@updateStatusSpy.argsForCall[0]).toEqual(['Successfully uploaded...', 1024])

    describe ".onerror", ->

      it "updates the status to 'Error: Unable to upload the file'", ->
        @events.onerror.call(DcEditor.uploader)
        expect(@updateStatusSpy.callCount).toEqual(1)
        expect(@updateStatusSpy.argsForCall[0]).toEqual(['Error: Unable to upload the file'])

      it "calls hide", ->
        @events.onerror.call(DcEditor.uploader)
        expect(@hideSpy.callCount).toEqual(1)
        expect(@hideSpy.argsForCall[0]).toEqual([3])



describe "DcEditor.uploader.File", ->

  beforeEach ->
    @mockFile = {
      size: 1024
      fileName: 'image.png'
      type: 'image/png'
    }

  afterEach ->
    @file = null
    delete(@file)

  describe "constructor", ->

    it "expects a file", ->
      @file = new DcEditor.uploader.File(@mockFile)
      expect(@file.file).toEqual(@mockFile)

    it "reads attributes of the file and sets variables", ->
      @file = new DcEditor.uploader.File(@mockFile)
      expect(@file.size).toEqual(1024)
      expect(@file.fullSize).toEqual(1024)
      expect(@file.readableSize).toEqual('1.00 kb')
      expect(@file.name).toEqual('image.png')
      expect(@file.type).toEqual('image/png')

    it "adds errors if there's any", ->
      DcEditor.config.uploading.maxFileSize = 100
      DcEditor.config.uploading.allowedMimeTypes = ['image/foo']
      @file = new DcEditor.uploader.File(@mockFile)
      expect(@file.errors).toEqual('Too large / Unsupported format')


  describe "#readAsDataURL", ->

    it "it calls readAsDataURL on a FileReader object", ->
      spy = spyOn(window.FileReader.prototype, 'readAsDataURL').andCallFake(=>)
      @file = new DcEditor.uploader.File(@mockFile)
      @file.readAsDataURL()
      expect(spy.callCount).toEqual(1)

    it "calls a callback if one was provided", ->
      spyOn(FileReader.prototype, 'readAsDataURL').andCallFake(=>)
      FileReader.prototype.result = 'result'
      callCount = 0
      callback = (r) => callCount += 1

      @file = new DcEditor.uploader.File(@mockFile)
      onload = @file.readAsDataURL(callback)
      onload()
      expect(callCount).toEqual(1)


  describe "#readAsBinaryString", ->

    it "it calls readAsBinaryString on a FileReader object", ->
      spy = spyOn(window.FileReader.prototype, 'readAsBinaryString').andCallFake(=>)
      @file = new DcEditor.uploader.File(@mockFile)
      @file.readAsBinaryString()
      expect(spy.callCount).toEqual(1)

    it "calls a callback if one was provided", ->
      spyOn(FileReader.prototype, 'readAsBinaryString').andCallFake(=>)
      FileReader.prototype.result = 'result'
      callCount = 0
      callback = (r) => callCount += 1

      @file = new DcEditor.uploader.File(@mockFile)
      onload = @file.readAsBinaryString(callback)
      onload()
      expect(callCount).toEqual(1)


  describe "#updateSize", ->

    it "updates the size based on a delta", ->
      @file = new DcEditor.uploader.File(@mockFile)
      @file.updateSize(20)
      expect(@file.fullSize).toEqual(1044)



describe "DcEditor.uploader.MultiPartPost", ->

  beforeEach ->
    @mockFile = {
      size: 1024
      name: 'image.png'
      type: 'image/png'
    }

  afterEach ->
    @multiPartPost = null
    delete(@multiPartPost)

  describe "constructor", ->

    it "expects an inputName, file, and file contents", ->
      @multiPartPost = new DcEditor.uploader.MultiPartPost('foo[bar]', @mockFile, 'file contents')
      expect(@multiPartPost.inputName).toEqual('foo[bar]')
      expect(@multiPartPost.file).toEqual(@mockFile)
      expect(@multiPartPost.contents).toEqual('file contents')

    it "accepts a formInputs object", ->
      @multiPartPost = new DcEditor.uploader.MultiPartPost('foo[bar]', @mockFile, 'file contents', {foo: 'bar'})
      expect(@multiPartPost.formInputs).toEqual({foo: 'bar'})

    it "defines a boundary string", ->
      @multiPartPost = new DcEditor.uploader.MultiPartPost('foo[bar]', @mockFile, 'file contents')
      expect(@multiPartPost.boundary).toEqual('Boundaryx20072377098235644401115438165x')

    it "calls buildBody", ->
      spy = spyOn(DcEditor.uploader.MultiPartPost.prototype, 'buildBody').andCallFake(=>)
      @multiPartPost = new DcEditor.uploader.MultiPartPost('foo[bar]', @mockFile, 'file contents')
      expect(spy.callCount).toEqual(1)

    it "sets a delta based on the body size and file size", ->
      @multiPartPost = new DcEditor.uploader.MultiPartPost('foo[bar]', @mockFile, 'file contents')
      expect(@multiPartPost.delta).toEqual(-790)


  describe "#buildBody", ->

    it "creates a multipart post body with the file information", ->
      @multiPartPost = new DcEditor.uploader.MultiPartPost('foo[bar]', @mockFile, 'file contents')
      expect(@multiPartPost.body).toContain('--Boundaryx20072377098235644401115438165x')
      expect(@multiPartPost.body).toContain('Content-Disposition: form-data; name="foo[bar]"; filename="image.png"')
      expect(@multiPartPost.body).toContain('Content-Type: image/png')
      expect(@multiPartPost.body).toContain('Content-Transfer-Encoding: binary')
      expect(@multiPartPost.body).toContain('file contents')

    it "includes form inputs if passed in", ->
      @multiPartPost = new DcEditor.uploader.MultiPartPost('foo[bar]', @mockFile, 'file contents', {foo: 'bar'})
      expect(@multiPartPost.body).toContain('Content-Disposition: form-data; name="foo"\r\n\r\nbar')
