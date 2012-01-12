describe "DcEditor.modal", ->

  template 'dc_editor/modal.html'

  beforeEach ->
    $.fx.off = true
    DcEditor.displayRect = {fullHeight: 200}
    DcEditor.determinedLocale =
      top: {'hello world!': 'bork! bork!'}
      sub: {'foo': 'Bork!'}

  afterEach ->
    DcEditor.config.localization.enabled = false
    DcEditor.modal.initialized = false
    DcEditor.modal.visible = false
    $(window).unbind('dc_editor:refresh')
    $(window).unbind('dc_editor:resize')
    $(document).unbind('keydown')

  describe "singleton method", ->

    beforeEach ->
      @showSpy = spyOn(DcEditor.modal, 'show').andCallFake(=>)

    it "calls show", ->
      DcEditor.modal('/foo')
      expect(@showSpy.callCount).toEqual(1)

    it "returns the function object", ->
      ret = DcEditor.modal('/foo')
      expect(ret).toEqual(DcEditor.modal)


  describe "#show", ->

    beforeEach ->
      @initializeSpy = spyOn(DcEditor.modal, 'initialize').andCallFake(=>)
      @updateSpy = spyOn(DcEditor.modal, 'update').andCallFake(=>)
      @appearSpy = spyOn(DcEditor.modal, 'appear').andCallFake(=>)

    it "triggers the focus:window event", ->
      spy = spyOn(DcEditor, 'trigger').andCallFake(=>)
      DcEditor.modal.show()
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['focus:window'])

    it "calls initialize", ->
      DcEditor.modal.show()
      expect(@initializeSpy.callCount).toEqual(1)

    describe "if already visible", ->

      it "calls update", ->
        DcEditor.modal.visible = true
        DcEditor.modal.show()
        expect(@updateSpy.callCount).toEqual(1)

    describe "if not visible", ->

      it "calls appear", ->
        DcEditor.modal.show()
        expect(@appearSpy.callCount).toEqual(1)


  describe "#initialize", ->

    beforeEach ->
      @buildSpy = spyOn(DcEditor.modal, 'build').andCallFake(=>)
      @bindEventsSpy = spyOn(DcEditor.modal, 'bindEvents').andCallFake(=>)

    it "calls build", ->
      DcEditor.modal.initialize()
      expect(@buildSpy.callCount).toEqual(1)

    it "calls bindEvents", ->
      DcEditor.modal.initialize()
      expect(@bindEventsSpy.callCount).toEqual(1)

    it "does nothing if already initialized", ->
      DcEditor.modal.initialized = true
      DcEditor.modal.initialize()
      expect(@buildSpy.callCount).toEqual(0)

    it "sets initialized to true", ->
      DcEditor.modal.initialize()
      expect(DcEditor.modal.initialized).toEqual(true)


  describe "#build", ->

    beforeEach ->
      DcEditor.modal.options = {appendTo: $('#test')}

    it "builds an element", ->
      DcEditor.modal.build()
      expect($('#test .dc_editor-modal').length).toEqual(1)

    it "builds an overlay element", ->
      DcEditor.modal.build()
      expect($('#test .dc_editor-modal-overlay').length).toEqual(1)

    it "creates a titleElement", ->
      DcEditor.modal.build()
      expect($('#test .dc_editor-modal-title').length).toEqual(1)
      expect($('#test .dc_editor-modal-title').html()).toMatch(/<span><\/span><a>.+<\/a>/)
      expect(DcEditor.modal.titleElement).toBeDefined()

    it "creates a contentContainerElement", ->
      DcEditor.modal.build()
      expect($('#test .dc_editor-modal-content-container').length).toEqual(1)
      expect(DcEditor.modal.contentContainerElement).toBeDefined()

    it "creates a contentElement", ->
      DcEditor.modal.build()
      expect($('#test .dc_editor-modal-content-container .dc_editor-modal-content').length).toEqual(1)
      expect(DcEditor.modal.contentElement).toBeDefined()

    it "appends to any element", ->
      DcEditor.modal.options = {appendTo: $('#modal_container')}
      DcEditor.modal.build()
      expect($('#modal_container .dc_editor-modal').length).toEqual(1)
      expect($('#modal_container .dc_editor-modal-overlay').length).toEqual(1)


  describe "observed events", ->

    beforeEach ->
      spyOn(DcEditor.modal, 'appear').andCallFake(=>)
      DcEditor.modal('/foo', {appendTo: $('#test')})

    describe "custom event: refresh", ->

      it "calls resize telling it stay visible", ->
        spy = spyOn(DcEditor.modal, 'resize').andCallFake(=>)
        DcEditor.trigger('refresh')
        expect(spy.callCount).toEqual(1)
        expect(spy.argsForCall[0]).toEqual([true])

    describe "custom event: resize", ->

      it "calls position", ->
        spy = spyOn(DcEditor.modal, 'position').andCallFake(=>)
        DcEditor.trigger('resize')
        expect(spy.callCount).toEqual(1)

    describe "clicking on the overlay (options.allowHideUsingOverlay = true)", ->

      it "calls hide", ->
        DcEditor.modal.options.allowHideUsingOverlay = true
        spy = spyOn(DcEditor.modal, 'hide').andCallFake(=>)
        jasmine.simulate.click($('.dc_editor-modal-overlay').get(0))
        expect(spy.callCount).toEqual(1)

    describe "clicking on the overlay (options.allowHideUsingOverlay = false)", ->

      it "doesn't call hide", ->
        spy = spyOn(DcEditor.modal, 'hide').andCallFake(=>)
        jasmine.simulate.click($('.dc_editor-modal-overlay').get(0))
        expect(spy.callCount).toEqual(0)

    describe "clicking on the close button", ->

      it "calls hide", ->
        spy = spyOn(DcEditor.modal, 'hide').andCallFake(=>)
        jasmine.simulate.click($('.dc_editor-modal-title a').get(0))
        expect(spy.callCount).toEqual(1)

    describe "pressing esc on document", ->

      beforeEach ->
        DcEditor.modal.visible = true
      
      it "calls hide", ->
        spy = spyOn(DcEditor.modal, 'hide').andCallFake(=>)
        jasmine.simulate.keydown(document, {keyCode: 27})
        expect(spy.callCount).toEqual(1)

    describe "ajax:beforeSend", ->

      it "sets a success that will load the contents of the response", ->
        options = {}
        spy = spyOn(DcEditor.modal, 'loadContent').andCallFake(=>)
        DcEditor.modal.element.trigger('ajax:beforeSend', [null, options])
        expect(options.success).toBeDefined()
        options.success('new content')
        expect(spy.callCount).toEqual(1)
        expect(spy.argsForCall[0]).toEqual(['new content'])


  describe "#appear", ->

    beforeEach ->
      DcEditor.modal.visible = true
      spyOn(DcEditor.modal, 'update').andCallFake(=>)
      @loadSpy = spyOn(DcEditor.modal, 'load').andCallFake(=>)
      @positionSpy = spyOn(DcEditor.modal, 'position').andCallFake(=>)
      DcEditor.modal('/evergreen/responses/blank.html', {appendTo: $('#test')})

    it "calls position", ->
      DcEditor.modal.appear()
      expect(@positionSpy.callCount).toEqual(1)

    it "shows the overlay", ->
      expect($('.dc_editor-modal-overlay').css('display')).toEqual('none')
      DcEditor.modal.appear()
      expect($('.dc_editor-modal-overlay').css('display')).toEqual('block')

    it "animates the overlay to full opacity", ->
      expect($('.dc_editor-modal-overlay').css('opacity')).toEqual('0')
      DcEditor.modal.appear()
      expect($('.dc_editor-modal-overlay').css('opacity')).toEqual('1')

    it "calls setTitle", ->
      spy = spyOn(DcEditor.modal, 'setTitle').andCallFake(=>)
      DcEditor.modal.appear()
      expect(spy.callCount).toEqual(1)

    it "shows the element", ->
      expect($('.dc_editor-modal').css('display')).toEqual('none')
      DcEditor.modal.appear()
      expect($('.dc_editor-modal').css('display')).toEqual('block')

    it "animates the element down", ->
      expect($('.dc_editor-modal').css('top')).toEqual('-100px')
      DcEditor.modal.appear()
      expect($('.dc_editor-modal').css('top')).toEqual('0px')

    it "sets visible to true", ->
      DcEditor.modal.visible = false
      DcEditor.modal.appear()
      expect(DcEditor.modal.visible).toEqual(true)

    it "calls load", ->
      DcEditor.modal.appear()
      expect(@loadSpy.callCount).toEqual(1)


  describe "#resize", ->

    beforeEach ->
      spyOn(DcEditor.modal, 'appear').andCallFake(=>)
      DcEditor.modal('/evergreen/responses/blank.html', {appendTo: $('#test')})
      DcEditor.modal.contentPane = $()

    it "will keep the content element visible if asked to do so", ->
      $('.dc_editor-modal-content').css('visibility', 'visible')
      DcEditor.modal.resize(true)
      expect($('.dc_editor-modal-content').css('visibility')).toEqual('visible')

    it "resizes the element and adjusts it's position", ->
      DcEditor.displayRect.width = 1000
      $('.dc_editor-modal').css({display: 'block', visibility: 'visible', top: 0})
      DcEditor.modal.resize()
      expect($('.dc_editor-modal').width()).toEqual(400)
      expect($('.dc_editor-modal').offset()).toEqual({top: 0, left: 300})
      expect($('.dc_editor-modal').height()).toBeGreaterThan(20)

    it "respects minWidth provided in options", ->
      DcEditor.modal.minWidth = 500
      DcEditor.modal.resize()
      expect($('.dc_editor-modal').width()).toEqual(500)


  describe "#position", ->

    beforeEach ->
      spyOn(DcEditor.modal, 'appear').andCallFake(=>)

    # todo: test this
    it "positions the element", ->


  describe "#update", ->

    beforeEach ->
      @resetSpy = spyOn(DcEditor.modal, 'reset').andCallFake(=>)
      @resizeSpy = spyOn(DcEditor.modal, 'resize').andCallFake(=>)
      @loadSpy = spyOn(DcEditor.modal, 'load').andCallFake(=>)
      DcEditor.modal.update()

    it "calls reset", ->
      expect(@resetSpy.callCount).toEqual(1)

    it "calls resize", ->
      expect(@resizeSpy.callCount).toEqual(1)

    it "calls load", ->
      expect(@loadSpy.callCount).toEqual(1)


  describe "#load", ->

    beforeEach ->
      spyOn(DcEditor.modal, 'appear').andCallFake(=>)
      @ajaxSpy = spyOn($, 'ajax')
      DcEditor.modal('/evergreen/responses/blank.html', {appendTo: $('#test')})

    it "does nothing if there's no url", ->
      DcEditor.modal.url = null
      $('.dc_editor-modal').removeClass('loading')
      DcEditor.modal.load()
      expect($('.dc_editor-modal').hasClass('loading')).toEqual(false)

    it "sets the loading class on the element", ->
      DcEditor.modal.load()
      expect($('.dc_editor-modal').hasClass('loading')).toEqual(true)

    it "calls setTitle", ->
      spy = spyOn(DcEditor.modal, 'setTitle').andCallFake(=>)
      DcEditor.modal.load()
      expect(spy.callCount).toEqual(1)

    describe "on a preloaded view", ->

      beforeEach ->
        @setTimeoutSpy = spyOn(window, 'setTimeout').andCallFake((timeout, callback) => callback())
        DcEditor.preloadedViews = {'/evergreen/responses/blank.html': 'this is the preloaded content'}

      afterEach ->
        DcEditor.preloadedViews = {}

      it "calls loadContent with the content in the preloaded view", ->
        spy = spyOn(DcEditor.modal, 'loadContent').andCallFake(=>)
        DcEditor.modal.load()
        expect(@setTimeoutSpy.callCount).toEqual(1)
        expect(spy.callCount).toEqual(1)

    describe "when not a preloaded view", ->

      it "makes an ajax request", ->
        @ajaxSpy.andCallFake(=>)
        spyOn(DcEditor, 'ajaxHeaders').andCallFake(=> {'X-CSRFToken': 'f00'})
        DcEditor.modal.load()
        expect(@ajaxSpy.callCount).toEqual(1)
        expect(@ajaxSpy.argsForCall[0][1]['headers']).toEqual({'X-CSRFToken': 'f00'})

      describe "on success", ->

        beforeEach ->
          @ajaxSpy.andCallFake((url, options) => options.success('return value'))

        it "calls loadContent and passes the returned data", ->
          spy = spyOn(DcEditor.modal, 'loadContent').andCallFake(=>)
          DcEditor.modal.load()
          expect(spy.callCount).toEqual(1)
          expect(spy.argsForCall[0]).toEqual(['return value'])

      describe "on failure", ->

        beforeEach ->
          @ajaxSpy.andCallFake((url, options) => options.error())

        it "calls hide", ->
          spyOn(window, 'alert').andCallFake(=>)
          spy = spyOn(DcEditor.modal, 'hide').andCallFake(=>)
          DcEditor.modal.load()
          expect(spy.callCount).toEqual(1)

        it "alerts an error message", ->
          spyOn(DcEditor.modal, 'hide').andCallFake(=>)
          spy = spyOn(window, 'alert').andCallFake(=>)
          DcEditor.modal.load()
          expect(spy.callCount).toEqual(1)
          expect(spy.argsForCall[0]).toEqual(['DcEditor was unable to load /evergreen/responses/blank.html for the modal.'])


  describe "#loadContent", ->

    beforeEach ->
      spyOn(DcEditor.modal, 'appear').andCallFake(=>)
      @resizeSpy = spyOn(DcEditor.modal, 'resize').andCallFake(=>)
      DcEditor.modal('/evergreen/responses/blank.html', {appendTo: $('#test'), title: 'title'})

    it "accepts options and sets them to the instance options", ->
      DcEditor.modal.loadContent('content', {title: 'title'})
      expect(DcEditor.modal.options).toEqual({title: 'title'})

    it "calls initialize", ->
      spy = spyOn(DcEditor.modal, 'initialize').andCallFake(=>)
      DcEditor.modal.loadContent('content')
      expect(spy.callCount).toEqual(1)

    it "calls setTitle", ->
      spy = spyOn(DcEditor.modal, 'setTitle').andCallFake(=>)
      DcEditor.modal.loadContent('content')
      expect(spy.callCount).toEqual(1)

    it "sets loaded to true", ->
      DcEditor.modal.loaded = false
      DcEditor.modal.loadContent('content')
      expect(DcEditor.modal.loaded).toEqual(true)

    it "removes the loading class", ->
      $('.dc_editor-modal').addClass('loading')
      DcEditor.modal.loadContent('content')
      expect($('.dc_editor-modal').hasClass('loading')).toEqual(false)

    it "sets the content elements html to whatever was passed", ->
      DcEditor.modal.loadContent('<span>content</span>')
      expect($('.dc_editor-modal-content').html()).toEqual('<span>content</span>')

    it "hides the contentElement", ->
      $('.dc_editor-modal-content').css('display', 'block')
      DcEditor.modal.loadContent('content')
      expect($('.dc_editor-modal-content').css('display')).toEqual('none')
      expect($('.dc_editor-modal-content').css('visibility')).toEqual('hidden')

    it "finds the content panes and control elements in case they were added with the content", ->
      DcEditor.modal.loadContent('<div class="dc_editor-display-pane-container"></div><div class="dc_editor-display-controls"></div>')
      expect(DcEditor.modal.contentPane.get(0)).toEqual($('#test .dc_editor-display-pane-container').get(0))
      expect(DcEditor.modal.contentControl.get(0)).toEqual($('#test .dc_editor-display-controls').get(0))

    it "calls an afterLoad callback (if provided in options)", ->
      callCount = 0
      DcEditor.modal.loadContent('content', {afterLoad: => callCount += 1})
      expect(callCount).toEqual(1)

    it "calls a handler method if one is set in modalHandlers", ->
      callCount = 0
      DcEditor.modalHandlers['foo'] = => callCount += 1
      DcEditor.modal.loadContent('content', {handler: 'foo'})
      expect(callCount).toEqual(1)

    it "translates the content if configured", ->
      DcEditor.config.localization.enabled = true
      DcEditor.modal.loadContent('<span>foo</span>')
      expect($('.dc_editor-modal-content').html()).toEqual('<span>Bork!</span>')

    it "calls resize", ->
      DcEditor.modal.loadContent('content')
      expect(@resizeSpy.callCount).toEqual(1)


  describe "#setTitle", ->

    beforeEach ->
      spyOn(DcEditor.modal, 'appear').andCallFake(=>)
      DcEditor.modal('/evergreen/responses/blank.html', {appendTo: $('#test'), title: 'title'})

    it "sets the the title contents to what was provided in the options", ->
      DcEditor.modal.options = {title: 'new title'}
      DcEditor.modal.setTitle()
      expect($('.dc_editor-modal-title span').html()).toEqual('new title')


  describe "#reset", ->

    beforeEach ->
      spyOn(DcEditor.modal, 'appear').andCallFake(=>)
      DcEditor.modal('/evergreen/responses/blank.html', {appendTo: $('#test'), title: 'title'})

    it "clears the title and content elements", ->
      $('.dc_editor-modal-content').html('content')
      DcEditor.modal.reset()
      expect($('.dc_editor-modal-content').html()).toEqual('')
      expect($('.dc_editor-modal-title span').html()).toEqual('')


  describe "#hide", ->

    beforeEach ->
      spyOn(DcEditor.modal, 'appear').andCallFake(=>)
      DcEditor.modal('/evergreen/responses/blank.html', {appendTo: $('#test')})

    it "triggers the focus:frame event", ->
      spy = spyOn(DcEditor, 'trigger').andCallFake(=>)
      DcEditor.modal.hide()
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['focus:frame'])

    it "hides the element", ->
      DcEditor.modal.element.css('display:block')
      DcEditor.modal.hide()
      expect($('.dc_editor-modal').css('display')).toEqual('none')

    it "hides the overlay element", ->
      DcEditor.modal.overlay.css('display:block')
      DcEditor.modal.hide()
      expect($('.dc_editor-modal-overlay').css('display')).toEqual('none')

    it "calls reset", ->
      spy = spyOn(DcEditor.modal, 'reset').andCallFake(=>)
      DcEditor.modal.hide()
      expect(spy.callCount).toEqual(1)

    it "sets visible to false", ->
      DcEditor.modal.visible = true
      DcEditor.modal.hide()
      expect(DcEditor.modal.visible).toEqual(false)

    it "does nothing if the modal is still in the process of showing", ->
      spy = spyOn(DcEditor.modal, 'reset').andCallFake(=>)
      DcEditor.modal.showing = true
      DcEditor.modal.hide()
      expect(spy.callCount).toEqual(0)


