describe "DcEditor.Dialog", ->

  template 'dc_editor/dialog.html'

  beforeEach ->
    $.fx.off = true
    DcEditor.determinedLocale =
      top: {'hello world!': 'bork! bork!'}
      sub: {'foo': 'Bork!'}

  afterEach ->
    delete(@dialog)
    DcEditor.config.localization.enabled = false


  describe "constructor", ->

    beforeEach ->
      @buildSpy = spyOn(DcEditor.Dialog.prototype, 'build').andCallFake(=>)
      @bindEventsSpy = spyOn(DcEditor.Dialog.prototype, 'bindEvents').andCallFake(=>)
      @preloadSpy = spyOn(DcEditor.Dialog.prototype, 'preload').andCallFake(=>)

    it "expects a url and name", ->
      @dialog = new DcEditor.Dialog('/evergreen/responses/blank.html', 'foo')
      expect(@dialog.url).toEqual('/evergreen/responses/blank.html')
      expect(@dialog.name).toEqual('foo')

    it "accepts options", ->
      @dialog = new DcEditor.Dialog('/evergreen/responses/blank.html', 'foo', {for: 'something', foo: 'bar'})
      expect(@dialog.options).toEqual({for: 'something', foo: 'bar'})

    it "calls build", ->
      @dialog = new DcEditor.Dialog()
      expect(@buildSpy.callCount).toEqual(1)

    it "calls bindEvents", ->
      @dialog = new DcEditor.Dialog()
      expect(@bindEventsSpy.callCount).toEqual(1)

    it "preloads if configured", ->
      @dialog = new DcEditor.Dialog()
      expect(@preloadSpy.callCount).toEqual(1)


  describe "#build", ->

    beforeEach ->
      @bindEventsSpy = spyOn(DcEditor.Dialog.prototype, 'bindEvents').andCallFake(=>)
      @preloadSpy = spyOn(DcEditor.Dialog.prototype, 'preload').andCallFake(=>)

    it "builds an element", ->
      @dialog = new DcEditor.Dialog('/evergreen/responses/blank.html', 'foo', {appendTo: '#test'})
      html = $('<div>').html(@dialog.element).html()
      expect(html).toContain('class="dc_editor-dialog dc_editor-foo-dialog loading"')
      expect(html).toContain('style="display:none"')

    it "appends to any element", ->
      @dialog = new DcEditor.Dialog('/evergreen/responses/blank.html', 'foo', {appendTo: '#dialog_container'})
      expect($('#dialog_container .dc_editor-dialog').length).toEqual(1)


  describe "#bindEvents", ->

    it "only observes mousedown to stop the event"


  describe "#preload", ->

    beforeEach ->
      @loadSpy = spyOn(DcEditor.Dialog.prototype, 'load').andCallFake(=>)

    it "calls load if configured", ->
      @dialog = new DcEditor.Dialog('/evergreen/responses/blank.html', 'foo', {appendTo: '#test', preload: true})
      expect(@loadSpy.callCount).toEqual(1)

    it "doesn't call load if configured", ->
      @dialog = new DcEditor.Dialog('/evergreen/responses/blank.html', 'foo', {appendTo: '#test', preload: false})
      expect(@loadSpy.callCount).toEqual(0)


  describe "#toggle", ->

    beforeEach ->
      @dialog = new DcEditor.Dialog('/evergreen/responses/blank.html', 'foo', {appendTo: '#test'})

    it "shows or hides", ->
      expect(@dialog.element.css('display')).toEqual('none')
      @dialog.toggle()
      expect(@dialog.element.css('display')).toEqual('block')
      @dialog.toggle()
      expect(@dialog.element.css('display')).toEqual('none')


  describe "#resize", ->

    beforeEach ->
      @dialog = new DcEditor.Dialog('/evergreen/responses/blank.html', 'foo', {appendTo: '#test'})

    it "calls show", ->
      spy = spyOn(DcEditor.Dialog.prototype, 'show').andCallFake(=>)
      @dialog.resize()
      expect(spy.callCount).toEqual(1)


  describe "#show", ->

    beforeEach ->
      @dialog = new DcEditor.Dialog('/evergreen/responses/blank.html', 'foo', {appendTo: '#test'})

    it "triggers a custom event to hide all other dialogs", ->
      spy = spyOn(DcEditor, 'trigger').andCallFake(=>)
      @dialog.show()
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['hide:dialogs', @dialog])

    describe "when already loaded", ->

      beforeEach ->
        @dialog.loaded = true

      it "sets width and height on the element to auto", ->
        @dialog.element.css({width: 100})
        @dialog.show()
        expect(@dialog.element.get(0).style.width).toEqual('auto')
        expect(@dialog.element.get(0).style.height).toEqual('auto')

      it "calls position", ->
        spy = spyOn(DcEditor.Dialog.prototype, 'position').andCallFake(=>)
        @dialog.show()
        expect(spy.callCount).toEqual(1)
        expect(spy.argsForCall[0]).toEqual([true])

      it "calls appear", ->
        spy = spyOn(DcEditor.Dialog.prototype, 'appear').andCallFake(=>)
        @dialog.show()
        expect(spy.callCount).toEqual(1)

    describe "when not loaded", ->

      it "calls position", ->
        spy = spyOn(DcEditor.Dialog.prototype, 'position').andCallFake(=>)
        @dialog.show()
        expect(spy.callCount).toEqual(1)
        expect(spy.argsForCall[0]).toEqual([])

      it "calls appear", ->
        spy = spyOn(DcEditor.Dialog.prototype, 'appear').andCallFake(=>)
        @dialog.show()
        expect(spy.callCount).toEqual(1)


  describe "#position", ->

    it "does nothing and is there as an interface method"


  describe "#appear", ->

    beforeEach ->
      @dialog = new DcEditor.Dialog('/evergreen/responses/blank.html', 'foo', {appendTo: '#test'})

    it "animates the dialog in", ->
      @dialog.appear()
      expect(@dialog.element.css('display')).toEqual('block')
      expect(parseFloat(@dialog.element.css('opacity')).toPrecision(2)).toEqual('0.95')

    it "calls load if it's not already loaded", ->


  describe "#hide", ->

    beforeEach ->
      @dialog = new DcEditor.Dialog('/evergreen/responses/blank.html', 'foo', {appendTo: '#test'})

    it "hides the dialog", ->
      @dialog.element.css({display: 'block'})
      @dialog.hide()
      expect(@dialog.element.css('display')).toEqual('none')
      expect(@dialog.visible).toEqual(false)


  describe "#load", ->

    beforeEach ->
      @spyFunction = ->
      DcEditor.dialogHandlers.foo = ->
      @dialog = new DcEditor.Dialog('/evergreen/responses/blank.html', 'foo', {appendTo: '#test', for: $('#button')})

    it "does nothing if there's no url", ->
      spy = spyOn($, 'ajax').andCallFake(=>)
      @dialog.url = false
      @dialog.load()
      expect(spy.callCount).toEqual(0)

    describe "on a preloaded view", ->

      beforeEach ->
        DcEditor.preloadedViews = {'/evergreen/responses/blank.html': 'this is the preloaded content'}

      afterEach ->
        DcEditor.preloadedViews = {}

      it "calls loadContent with the content in the preloaded view", ->
        spy = spyOn(DcEditor.Dialog.prototype, 'loadContent').andCallFake(=>)
        @dialog.load()
        expect(spy.callCount).toEqual(1)
        expect(spy.argsForCall[0]).toEqual(['this is the preloaded content'])

    describe "when not a preloaded view", ->

      it "makes an ajax request", ->
        spy = spyOn($, 'ajax').andCallFake(=>)
        @dialog.load()
        expect(spy.callCount).toEqual(1)

      describe "on success", ->

        beforeEach ->
          @loadContentSpy = spyOn(DcEditor.Dialog.prototype, 'loadContent').andCallFake(=>)
          @ajaxSpy = spyOn($, 'ajax').andCallFake (url, options) =>
            options.success('return value') if (options.success)

        it "calls loadContent with data", ->
          @dialog.load()
          expect(@loadContentSpy.callCount).toEqual(1)
          expect(@loadContentSpy.argsForCall[0]).toEqual(['return value'])

        it "calls a dialog handler if there's one", ->
          spy = spyOn(DcEditor.dialogHandlers, 'foo').andCallFake(=>)
          @dialog.load()
          expect(spy.callCount).toEqual(1)

        it "calls a callback if one was provided", ->
          spy = spyOn(@, 'spyFunction').andCallFake(=>)
          @dialog.load(@spyFunction)
          expect(spy.callCount).toEqual(1)

      describe "on failure", ->

        beforeEach ->
          @alertSpy = spyOn(window, 'alert').andCallFake(=>)
          @ajaxSpy = spyOn($, 'ajax').andCallFake (url, options) =>
            options.error() if (options.error)

        it "hides", ->
          spy = spyOn(DcEditor.Dialog.prototype, 'hide').andCallFake(=>)
          @dialog.load()
          expect(spy.callCount).toEqual(1)

        it "removes the pressed state for it's button", ->
          $('#button').addClass('pressed')
          @dialog.load()
          expect($('#button').hasClass('pressed')).toEqual(false)

        it "alerts the user", ->
          @dialog.load()
          expect(@alertSpy.callCount).toEqual(1)
          expect(@alertSpy.argsForCall[0]).toEqual(['DcEditor was unable to load /evergreen/responses/blank.html for the "foo" dialog.'])


  describe "#loadContent", ->

    beforeEach ->
      @dialog = new DcEditor.Dialog('/evergreen/responses/blank.html', 'foo', {appendTo: '#test'})

    it "sets loaded to be true", ->
      @dialog.loadContent()
      expect(@dialog.loaded).toEqual(true)

    it "removes the loading class from the element", ->
      @dialog.loadContent()
      expect(@dialog.element.hasClass('loading')).toEqual(false)

    it "sets the element html to be the data passed to it", ->
      @dialog.loadContent('<span>hello world!</span>')
      expect(@dialog.element.html()).toEqual('<span>hello world!</span>')

    it "translates the content if configured", ->
      DcEditor.config.localization.enabled = true
      @dialog.loadContent('<span>hello world!</span>')
      expect(@dialog.element.html()).toEqual('<span>bork! bork!</span>')
