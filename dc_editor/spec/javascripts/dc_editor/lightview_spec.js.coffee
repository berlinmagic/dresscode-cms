describe "DcEditor.lightview", ->

  template 'dc_editor/lightview.html'

  beforeEach ->
    $.fx.off = true
    DcEditor.displayRect = {fullHeight: 200, width: 1000}
    DcEditor.determinedLocale =
      top: {'hello world!': 'bork! bork!'}
      sub: {'foo': 'Bork!'}

  afterEach ->
    DcEditor.config.localization.enabled = false
    DcEditor.lightview.initialized = false
    DcEditor.lightview.visible = false
    $(window).unbind('dc_editor:refresh')
    $(window).unbind('dc_editor:resize')
    $(document).unbind('keydown')

  describe "singleton method", ->

    beforeEach ->
      @showSpy = spyOn(DcEditor.lightview, 'show').andCallFake(=>)

    it "calls show", ->
      DcEditor.lightview('/foo')
      expect(@showSpy.callCount).toEqual(1)

    it "returns the function object", ->
      ret = DcEditor.lightview('/foo')
      expect(ret).toEqual(DcEditor.lightview)


  describe "#show", ->

    beforeEach ->
      @initializeSpy = spyOn(DcEditor.lightview, 'initialize').andCallFake(=>)
      @updateSpy = spyOn(DcEditor.lightview, 'update').andCallFake(=>)
      @appearSpy = spyOn(DcEditor.lightview, 'appear').andCallFake(=>)

    it "triggers the focus:window event", ->
      spy = spyOn(DcEditor, 'trigger').andCallFake(=>)
      DcEditor.lightview.show()
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['focus:window'])

    it "calls initialize", ->
      DcEditor.lightview.show()
      expect(@initializeSpy.callCount).toEqual(1)

    describe "if already visible", ->

      it "calls update", ->
        DcEditor.lightview.visible = true
        DcEditor.lightview.show()
        expect(@updateSpy.callCount).toEqual(1)

    describe "if not visible", ->

      it "calls appear", ->
        DcEditor.lightview.show()
        expect(@appearSpy.callCount).toEqual(1)


  describe "#initialize", ->

    beforeEach ->
      @buildSpy = spyOn(DcEditor.lightview, 'build').andCallFake(=>)
      @bindEventsSpy = spyOn(DcEditor.lightview, 'bindEvents').andCallFake(=>)

    it "calls build", ->
      DcEditor.lightview.initialize()
      expect(@buildSpy.callCount).toEqual(1)

    it "calls bindEvents", ->
      DcEditor.lightview.initialize()
      expect(@bindEventsSpy.callCount).toEqual(1)

    it "does nothing if already initialized", ->
      DcEditor.lightview.initialized = true
      DcEditor.lightview.initialize()
      expect(@buildSpy.callCount).toEqual(0)

    it "sets initialized to true", ->
      DcEditor.lightview.initialize()
      expect(DcEditor.lightview.initialized).toEqual(true)


  describe "#build", ->

    beforeEach ->
      DcEditor.lightview.options = {appendTo: $('#test')}

    it "builds an element", ->
      DcEditor.lightview.build()
      expect($('#test .dc_editor-lightview').length).toEqual(1)

    it "builds an overlay element", ->
      DcEditor.lightview.build()
      expect($('#test .dc_editor-lightview-overlay').length).toEqual(1)

    it "creates a titleElement", ->
      DcEditor.lightview.build()
      expect($('#test .dc_editor-lightview-title').length).toEqual(1)
      expect($('#test .dc_editor-lightview-title').html()).toEqual("<span><\/span>")
      expect(DcEditor.lightview.titleElement).toBeDefined()

    it "creates a contentElement", ->
      DcEditor.lightview.build()
      expect($('#test .dc_editor-lightview-content').length).toEqual(1)
      expect(DcEditor.lightview.contentElement).toBeDefined()

    it "appends to any element", ->
      DcEditor.lightview.options = {appendTo: $('#lightview_container')}
      DcEditor.lightview.build()
      expect($('#lightview_container .dc_editor-lightview').length).toEqual(1)
      expect($('#lightview_container .dc_editor-lightview-overlay').length).toEqual(1)

    it "creates a close button if asked to in the options", ->
      DcEditor.lightview.options.closeButton = true
      DcEditor.lightview.build()
      expect($('#test .dc_editor-lightview-close').length).toEqual(1)


  describe "observed events", ->

    beforeEach ->
      spyOn(DcEditor.lightview, 'appear').andCallFake(=>)

    describe "without a close button", ->

      beforeEach ->
        DcEditor.lightview('/foo', {appendTo: $('#test')})

      describe "custom event: refresh", ->

        it "calls resize telling it stay visible", ->
          spy = spyOn(DcEditor.lightview, 'resize').andCallFake(=>)
          DcEditor.trigger('refresh')
          expect(spy.callCount).toEqual(1)
          expect(spy.argsForCall[0]).toEqual([true])

      describe "custom event: resize", ->

        beforeEach ->
          DcEditor.lightview.visible = true

        it "calls position", ->
          spy = spyOn(DcEditor.lightview, 'position').andCallFake(=>)
          DcEditor.trigger('resize')
          expect(spy.callCount).toEqual(1)

      describe "clicking on the overlay", ->

        it "calls hide", ->
          spy = spyOn(DcEditor.lightview, 'hide').andCallFake(=>)
          jasmine.simulate.click($('.dc_editor-lightview-overlay').get(0))
          expect(spy.callCount).toEqual(1)

      describe "pressing esc on document", ->

        beforeEach ->
          DcEditor.lightview.visible = true

        it "calls hide", ->
          spy = spyOn(DcEditor.lightview, 'hide').andCallFake(=>)
          jasmine.simulate.keydown(document, {keyCode: 27})
          expect(spy.callCount).toEqual(1)

    describe "with a close button", ->

      beforeEach ->
        DcEditor.lightview('/foo', {appendTo: $('#test'), closeButton: true})

      describe "clicking on the close button", ->

        it "calls hide", ->
          spy = spyOn(DcEditor.lightview, 'hide').andCallFake(=>)
          jasmine.simulate.click($('.dc_editor-lightview-close').get(0))
          expect(spy.callCount).toEqual(1)

      describe "clicking on the overlay", ->

        it "doesn't call hide", ->
          spy = spyOn(DcEditor.lightview, 'hide').andCallFake(=>)
          jasmine.simulate.click($('.dc_editor-lightview-overlay').get(0))
          expect(spy.callCount).toEqual(0)

      describe "ajax:beforeSend", ->

        it "sets a success that will load the contents of the response", ->
          options = {}
          spy = spyOn(DcEditor.lightview, 'loadContent').andCallFake(=>)
          DcEditor.lightview.element.trigger('ajax:beforeSend', [null, options])
          expect(options.success).toBeDefined()
          options.success('new content')
          expect(spy.callCount).toEqual(1)
          expect(spy.argsForCall[0]).toEqual(['new content'])


  describe "#appear", ->

    beforeEach ->
      DcEditor.lightview.visible = true
      spyOn(DcEditor.lightview, 'update').andCallFake(=>)
      @loadSpy = spyOn(DcEditor.lightview, 'load').andCallFake(=>)
      @positionSpy = spyOn(DcEditor.lightview, 'position').andCallFake(=>)
      DcEditor.lightview('/evergreen/responses/blank.html', {appendTo: $('#test')})

    it "calls position", ->
      DcEditor.lightview.appear()
      expect(@positionSpy.callCount).toEqual(1)

    it "shows the overlay", ->
      expect($('.dc_editor-lightview-overlay').css('display')).toEqual('none')
      DcEditor.lightview.appear()
      expect($('.dc_editor-lightview-overlay').css('display')).toEqual('block')

    it "animates the overlay to full opacity", ->
      expect($('.dc_editor-lightview-overlay').css('opacity')).toEqual('0')
      DcEditor.lightview.appear()
      expect($('.dc_editor-lightview-overlay').css('opacity')).toEqual('1')

    it "calls setTitle", ->
      spy = spyOn(DcEditor.lightview, 'setTitle').andCallFake(=>)
      DcEditor.lightview.appear()
      expect(spy.callCount).toEqual(1)

    it "shows the element", ->
      expect($('.dc_editor-lightview').css('display')).toEqual('none')
      DcEditor.lightview.appear()
      expect($('.dc_editor-lightview').css('display')).toEqual('block')

    it "animates the element opacity", ->
      expect($('.dc_editor-lightview').css('opacity')).toEqual('0')
      DcEditor.lightview.appear()
      expect($('.dc_editor-lightview').css('opacity')).toEqual('1')

    it "sets visible to true", ->
      DcEditor.lightview.visible = false
      DcEditor.lightview.appear()
      expect(DcEditor.lightview.visible).toEqual(true)

    it "calls load", ->
      DcEditor.lightview.appear()
      expect(@loadSpy.callCount).toEqual(1)


  describe "#resize", ->

    beforeEach ->
      spyOn(DcEditor.lightview, 'appear').andCallFake(=>)
      DcEditor.lightview('/evergreen/responses/blank.html', {appendTo: $('#test')})
      DcEditor.lightview.contentPane = $()

    it "will keep the content element visible if asked to do so", ->
      $('.dc_editor-lightview-content').css('visibility', 'visible')
      DcEditor.lightview.resize(true)
      expect($('.dc_editor-lightview-content').css('visibility')).toEqual('visible')

    it "resizes the element and adjusts it's position when empty", ->
      $('.dc_editor-lightview').css({display: 'block', visibility: 'visible', top: 0})
      DcEditor.lightview.resize()
      expect($('.dc_editor-lightview').width()).toEqual(300)
      expect($('.dc_editor-lightview').offset()).toEqual({top: 35, left: 350})
      expect($('.dc_editor-lightview').height()).toEqual(150)

    it "resizes the element and adjusts it's position when it has content", ->
      DcEditor.lightview.loadContent('<div style="width:600px;height:400px"></div>')
      $('.dc_editor-lightview').css({display: 'block', visibility: 'visible', top: 0})
      DcEditor.lightview.resize()
      expect($('.dc_editor-lightview').width()).toEqual(300)
      expect($('.dc_editor-lightview').offset()).toEqual({top: 20, left: 350})
      expect($('.dc_editor-lightview').height()).toEqual(180)


  describe "#position", ->

    beforeEach ->
      spyOn(DcEditor.lightview, 'appear').andCallFake(=>)

    # todo: test this
    it "positions the element", ->


  describe "#update", ->

    beforeEach ->
      @resetSpy = spyOn(DcEditor.lightview, 'reset').andCallFake(=>)
      @resizeSpy = spyOn(DcEditor.lightview, 'resize').andCallFake(=>)
      @loadSpy = spyOn(DcEditor.lightview, 'load').andCallFake(=>)
      DcEditor.lightview.update()

    it "calls reset", ->
      expect(@resetSpy.callCount).toEqual(1)

    it "calls resize", ->
      expect(@resizeSpy.callCount).toEqual(1)

    it "calls load", ->
      expect(@loadSpy.callCount).toEqual(1)


  describe "#load", ->

    beforeEach ->
      spyOn(DcEditor.lightview, 'appear').andCallFake(=>)
      @ajaxSpy = spyOn($, 'ajax')
      DcEditor.lightview('/evergreen/responses/blank.html', {appendTo: $('#test')})

    it "does nothing if there's no url", ->
      DcEditor.lightview.url = null
      $('.dc_editor-lightview').removeClass('loading')
      DcEditor.lightview.load()
      expect($('.dc_editor-lightview').hasClass('loading')).toEqual(false)

    it "sets the loading class on the element", ->
      DcEditor.lightview.load()
      expect($('.dc_editor-lightview').hasClass('loading')).toEqual(true)

    it "calls setTitle", ->
      spy = spyOn(DcEditor.lightview, 'setTitle').andCallFake(=>)
      DcEditor.lightview.load()
      expect(spy.callCount).toEqual(1)

    describe "on a preloaded view", ->

      beforeEach ->
        @setTimeoutSpy = spyOn(window, 'setTimeout').andCallFake((timeout, callback) => callback())
        DcEditor.preloadedViews = {'/evergreen/responses/blank.html': 'this is the preloaded content'}

      afterEach ->
        DcEditor.preloadedViews = {}

      it "calls loadContent with the content in the preloaded view", ->
        spy = spyOn(DcEditor.lightview, 'loadContent').andCallFake(=>)
        DcEditor.lightview.load()
        expect(@setTimeoutSpy.callCount).toEqual(1)
        expect(spy.callCount).toEqual(1)

    describe "when not a preloaded view", ->

      it "makes an ajax request", ->
        @ajaxSpy.andCallFake(=>)
        spyOn(DcEditor, 'ajaxHeaders').andCallFake(=> {'X-CSRFToken': 'f00'})
        DcEditor.lightview.load()
        expect(@ajaxSpy.callCount).toEqual(1)
        expect(@ajaxSpy.argsForCall[0][1]['headers']).toEqual({'X-CSRFToken': 'f00'})

      describe "on success", ->

        beforeEach ->
          @ajaxSpy.andCallFake((url, options) => options.success('return value'))

        it "calls loadContent and passes the returned data", ->
          spy = spyOn(DcEditor.lightview, 'loadContent').andCallFake(=>)
          DcEditor.lightview.load()
          expect(spy.callCount).toEqual(1)
          expect(spy.argsForCall[0]).toEqual(['return value'])

      describe "on failure", ->

        beforeEach ->
          @ajaxSpy.andCallFake((url, options) => options.error())

        it "calls hide", ->
          spyOn(window, 'alert').andCallFake(=>)
          spy = spyOn(DcEditor.lightview, 'hide').andCallFake(=>)
          DcEditor.lightview.load()
          expect(spy.callCount).toEqual(1)

        it "alerts an error message", ->
          spyOn(DcEditor.lightview, 'hide').andCallFake(=>)
          spy = spyOn(window, 'alert').andCallFake(=>)
          DcEditor.lightview.load()
          expect(spy.callCount).toEqual(1)
          expect(spy.argsForCall[0]).toEqual(['DcEditor was unable to load /evergreen/responses/blank.html for the lightview.'])


  describe "#loadContent", ->

    beforeEach ->
      spyOn(DcEditor.lightview, 'appear').andCallFake(=>)
      @resizeSpy = spyOn(DcEditor.lightview, 'resize').andCallFake(=>)
      DcEditor.lightview('/evergreen/responses/blank.html', {appendTo: $('#test'), title: 'title'})

    it "accepts options and sets them to the instance options", ->
      DcEditor.lightview.loadContent('content', {title: 'title'})
      expect(DcEditor.lightview.options).toEqual({title: 'title'})

    it "calls initialize", ->
      spy = spyOn(DcEditor.lightview, 'initialize').andCallFake(=>)
      DcEditor.lightview.loadContent('content')
      expect(spy.callCount).toEqual(1)

    it "calls setTitle", ->
      spy = spyOn(DcEditor.lightview, 'setTitle').andCallFake(=>)
      DcEditor.lightview.loadContent('content')
      expect(spy.callCount).toEqual(1)

    it "sets loaded to true", ->
      DcEditor.lightview.loaded = false
      DcEditor.lightview.loadContent('content')
      expect(DcEditor.lightview.loaded).toEqual(true)

    it "removes the loading class", ->
      $('.dc_editor-lightview').addClass('loading')
      DcEditor.lightview.loadContent('content')
      expect($('.dc_editor-lightview').hasClass('loading')).toEqual(false)

    it "sets the content elements html to whatever was passed", ->
      DcEditor.lightview.loadContent('<span>content</span>')
      expect($('.dc_editor-lightview-content').html()).toEqual('<span>content</span>')

    it "hides the contentElement", ->
      $('.dc_editor-lightview-content').css('display', 'block')
      DcEditor.lightview.loadContent('content')
      expect($('.dc_editor-lightview-content').css('display')).toEqual('none')
      expect($('.dc_editor-lightview-content').css('visibility')).toEqual('hidden')

    it "calls an afterLoad callback (if provided in options)", ->
      callCount = 0
      DcEditor.lightview.loadContent('content', {afterLoad: => callCount += 1})
      expect(callCount).toEqual(1)

    it "calls a handler method if one is set in lightviewHandlers", ->
      callCount = 0
      DcEditor.lightviewHandlers['foo'] = => callCount += 1
      DcEditor.lightview.loadContent('content', {handler: 'foo'})
      expect(callCount).toEqual(1)

    it "translates the content if configured", ->
      DcEditor.config.localization.enabled = true
      DcEditor.lightview.loadContent('<span>foo</span>')
      expect($('.dc_editor-lightview-content').html()).toEqual('<span>Bork!</span>')

    it "calls resize", ->
      DcEditor.lightview.loadContent('content')
      expect(@resizeSpy.callCount).toEqual(1)


  describe "#setTitle", ->

    beforeEach ->
      spyOn(DcEditor.lightview, 'appear').andCallFake(=>)
      DcEditor.lightview('/evergreen/responses/blank.html', {appendTo: $('#test'), title: 'title'})

    it "sets the the title contents to what was provided in the options", ->
      DcEditor.lightview.options = {title: 'new title'}
      DcEditor.lightview.setTitle()
      expect($('.dc_editor-lightview-title span').html()).toEqual('new title')


  describe "#reset", ->

    beforeEach ->
      spyOn(DcEditor.lightview, 'appear').andCallFake(=>)
      DcEditor.lightview('/evergreen/responses/blank.html', {appendTo: $('#test'), title: 'title'})

    it "clears the title and content elements", ->
      $('.dc_editor-lightview-content').html('content')
      DcEditor.lightview.reset()
      expect($('.dc_editor-lightview-content').html()).toEqual('')
      expect($('.dc_editor-lightview-title span').html()).toEqual('')


  describe "#hide", ->

    beforeEach ->
      spyOn(DcEditor.lightview, 'appear').andCallFake(=>)
      DcEditor.lightview('/evergreen/responses/blank.html', {appendTo: $('#test')})

    it "triggers the focus:frame event", ->
      spy = spyOn(DcEditor, 'trigger').andCallFake(=>)
      DcEditor.lightview.hide()
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['focus:frame'])

    it "hides the element", ->
      DcEditor.lightview.element.css('display:block')
      DcEditor.lightview.hide()
      expect($('.dc_editor-lightview').css('display')).toEqual('none')

    it "hides the overlay element", ->
      DcEditor.lightview.overlay.css('display:block')
      DcEditor.lightview.hide()
      expect($('.dc_editor-lightview-overlay').css('display')).toEqual('none')

    it "calls reset", ->
      spy = spyOn(DcEditor.lightview, 'reset').andCallFake(=>)
      DcEditor.lightview.hide()
      expect(spy.callCount).toEqual(1)

    it "sets visible to false", ->
      DcEditor.lightview.visible = true
      DcEditor.lightview.hide()
      expect(DcEditor.lightview.visible).toEqual(false)
