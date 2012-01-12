describe "DcEditor.SnippetToolbar", ->

  template 'dc_editor/snippet_toolbar.html'

  beforeEach ->
    $.fx.off = true

  afterEach ->
    @snippetToolbar = null
    delete(@snippetToolbar)
    $(window).unbind('dc_editor:hide:toolbar')
    $(window).unbind('dc_editor:show:toolbar')

  describe "constructor", ->

    beforeEach ->
      spyOn(DcEditor.SnippetToolbar.prototype, 'build').andCallFake(=>)
      spyOn(DcEditor.SnippetToolbar.prototype, 'bindEvents').andCallFake(=>)

    it "expects document", ->
      @snippetToolbar = new DcEditor.SnippetToolbar($('document'))
      expect(@snippetToolbar.document).toEqual($('document'))

    it "accepts options", ->
      @snippetToolbar = new DcEditor.SnippetToolbar($('document'))
      expect(@snippetToolbar.document).toEqual($('document'))


  describe "#build", ->

    it "builds an element", ->
      @snippetToolbar = new DcEditor.SnippetToolbar($('document'), {appendTo: '#test'})
      html = $('<div>').html(@snippetToolbar.element).html()
      expect(html).toContain('class="dc_editor-toolbar dc_editor-snippet-toolbar"')
      expect(html).toContain('style="display:none"')

    it "appends to any element", ->
      @snippetToolbar = new DcEditor.SnippetToolbar($('document'), {appendTo: '#snippet_toolbar_container'})
      expect($('#snippet_toolbar_container .dc_editor-toolbar').length).toEqual(1)


  describe "observed events", ->

    beforeEach ->
      @snippetToolbar = new DcEditor.SnippetToolbar($('document'), {appendTo: '#test'})

    describe "custom event: show:toolbar", ->

      it "does nothing if there's no snippet", ->
        spy = spyOn(DcEditor.SnippetToolbar.prototype, 'show').andCallFake(=>)
        DcEditor.trigger('show:toolbar', {snippet: null})
        expect(spy.callCount).toEqual(0)

      it "calls show", ->
        spy = spyOn(DcEditor.SnippetToolbar.prototype, 'show').andCallFake(=>)
        DcEditor.trigger('show:toolbar', {snippet: $('#snippet')})
        expect(spy.callCount).toEqual(1)

    describe "custom event: hide:toolbar", ->

      it "does nothing if it's not for the snippet toolbar", ->
        spy = spyOn(DcEditor.SnippetToolbar.prototype, 'hide').andCallFake(=>)
        DcEditor.trigger('hide:toolbar', {type: 'foo'})
        expect(spy.callCount).toEqual(0)

      it "calls hide", ->
        spy = spyOn(DcEditor.SnippetToolbar.prototype, 'hide').andCallFake(=>)
        DcEditor.trigger('hide:toolbar', {type: 'snippet'})
        expect(spy.callCount).toEqual(1)

    describe "mousemove", ->

      it "clears the hide timeout", ->
        spy = spyOn(window, 'clearTimeout').andCallFake(=>)
        jasmine.simulate.mousemove($('#test .dc_editor-snippet-toolbar').get(0))
        expect(spy.callCount).toEqual(1)

    describe "mouseout", ->

      it "calls hide", ->
        spy = spyOn(DcEditor.SnippetToolbar.prototype, 'hide').andCallFake(=>)
        jasmine.simulate.mouseout($('#test .dc_editor-snippet-toolbar').get(0))
        expect(spy.callCount).toEqual(1)


  describe "#show", ->

    beforeEach ->
      @snippetToolbar = new DcEditor.SnippetToolbar($('document'), {appendTo: '#test'})
      @positionSpy = spyOn(DcEditor.SnippetToolbar.prototype, 'position').andCallFake(=>)
      @appearSpy = spyOn(DcEditor.SnippetToolbar.prototype, 'appear').andCallFake(=>)

    it "expects a snippet", ->
      @snippetToolbar.show({snippet: 'foo'})
      expect(@snippetToolbar.snippet).toEqual({snippet: 'foo'})

    it "calls position", ->
      @snippetToolbar.show()
      expect(@positionSpy.callCount).toEqual(1)

    it "calls appear", ->
      @snippetToolbar.show()
      expect(@appearSpy.callCount).toEqual(1)


  describe "#position", ->

    beforeEach ->
      DcEditor.displayRect = {top: 20}
      @snippetToolbar = new DcEditor.SnippetToolbar($('document'), {appendTo: '#test', visible: true})
      @snippetToolbar.snippet = $('#snippet')

    it "positions itself based on the snippet", ->
      @snippetToolbar.element.show()
      @snippetToolbar.position()
      if $.browser.webkit
        expect(@snippetToolbar.element.offset()).toEqual({top: 18, left : 200})
      else
        expect(@snippetToolbar.element.offset()).toEqual({top: 14, left : 200})


  describe "#appear", ->

    beforeEach ->
      @snippetToolbar = new DcEditor.SnippetToolbar($('document'), {appendTo: '#test'})

    it "clears the hide timeout", ->
      spy = spyOn(window, 'clearTimeout').andCallFake(=>)
      @snippetToolbar.appear()
      expect(spy.callCount).toEqual(1)

    it "sets visible", ->
      @snippetToolbar.appear()
      expect(@snippetToolbar.visible).toEqual(true)

    it "shows the element", ->
      @snippetToolbar.appear()
      expect(@snippetToolbar.element.css('display')).toEqual('block')


  describe "#hide", ->

    beforeEach ->
      @snippetToolbar = new DcEditor.SnippetToolbar($('document'), {appendTo: '#test'})

    it "it clears the hide timeout", ->
      spy = spyOn(window, 'clearTimeout').andCallFake(=>)
      @snippetToolbar.hide()
      expect(spy.callCount).toEqual(1)

    describe "immediately", ->

      beforeEach ->
        @snippetToolbar.element.show()

      it "hides the element", ->
        @snippetToolbar.hide(true)
        expect(@snippetToolbar.element.css('display')).toEqual('none')

      it "sets visible", ->
        @snippetToolbar.visible = true
        @snippetToolbar.hide(true)
        expect(@snippetToolbar.visible).toEqual(false)

    describe "not immediately", ->

      beforeEach ->
        @snippetToolbar.element.show()
        @setTimeoutSpy = spyOn(window, 'setTimeout')

      it "sets a timeout", ->
        @setTimeoutSpy.andCallFake(=>)
        @snippetToolbar.hide()
        expect(@setTimeoutSpy.callCount).toEqual(1)

      it "hides the element", ->
        @setTimeoutSpy.andCallFake((timeout, callback) => callback())
        @snippetToolbar.hide()
        expect(@snippetToolbar.element.css('display')).toEqual('none')

      it "sets visible", ->
        @setTimeoutSpy.andCallFake((timeout, callback) => callback())
        @snippetToolbar.hide()
        expect(@snippetToolbar.visible).toEqual(false)
