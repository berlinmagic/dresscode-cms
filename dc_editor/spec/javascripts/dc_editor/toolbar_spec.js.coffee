describe "DcEditor.Toolbar", ->

  template 'dc_editor/toolbar.html'

  beforeEach ->
    $.fx.off = true
    spyOn($, 'ajax').andCallFake (url, options) =>
      options.success('data') if options.success

  afterEach ->
    @toolbar = null
    delete(@toolbar)

  describe "constructor", ->

    beforeEach ->
      @buildSpy = spyOn(DcEditor.Toolbar.prototype, 'build').andCallFake(=>)
      @bindEventsSpy = spyOn(DcEditor.Toolbar.prototype, 'bindEvents').andCallFake(=>)
      @toolbar = new DcEditor.Toolbar({appendTo: '#test', foo: true})

    it "accepts options as an argument", ->
      expect(@toolbar.options).toEqual({appendTo: '#test', foo: true})

    it "calls build", ->
      expect(@buildSpy.callCount).toEqual(1)

    it "calls bindEvents", ->
      expect(@bindEventsSpy.callCount).toEqual(1)


  describe "#build", ->

    describe "with a primary toolbar", ->

      beforeEach ->
        @buildButtonSpy = spyOn(DcEditor.Toolbar.prototype, 'buildButton').andCallFake(=> $('<div>'))
        @toolbar = new DcEditor.Toolbar({appendTo: '#toolbar_container', visible: false})

      it "builds an element", ->
        expect($('.dc_editor-toolbar-container').length).toEqual(1)

      it "hides the element if options.visible is false", ->
        expect($('.dc_editor-toolbar-container').css('display')).toEqual('none')

      it "can append to any element", ->
        expect($('#toolbar_container .dc_editor-toolbar-container').length).toEqual(1)

      it "builds out toolbar elements from the configuration", ->
        expect($('.dc_editor-primary-toolbar').length).toEqual(1)
        expect($('.dc_editor-editable-toolbar').length).toEqual(1)
        expect($('.dc_editor-editable-toolbar').data('regions')).toEqual('editable,markupable')

      it "builds buttons etc.", ->
        expect(@buildButtonSpy.callCount).toBeGreaterThan(10)

      it "sets it's width back to 100%", ->
        expect(@toolbar.element.get(0).style.width).toEqual('100%')

      it "disables all but the primary toolbar", ->
        expect($('.dc_editor-editable-toolbar').hasClass('disabled')).toEqual(true)

      it "adds an expander when white-space: nowrap (meaning the toolbar shouldn't wrap)", ->
        expect($('.dc_editor-toolbar-button-container').length).toBeGreaterThan(1)
        expect($('.dc_editor-toolbar-expander').length).toEqual(1)

    describe "without a primary toolbar", ->

      beforeEach ->
        @primaryToolbar = DcEditor.config.toolbars.primary
        delete(DcEditor.config.toolbars.primary)
        @buildButtonSpy = spyOn(DcEditor.Toolbar.prototype, 'buildButton').andCallFake(=> $('<div>'))
        @toolbar = new DcEditor.Toolbar({appendTo: '#toolbar_container', visible: false})

      afterEach ->
        DcEditor.config.toolbars.primary = @primaryToolbar

      it "doesn't disable the toolbars", ->
        expect($('.dc_editor-editable-toolbar').hasClass('disabled')).toEqual(false)



  describe "#buildButton", ->

    beforeEach ->
      @toolbar = new DcEditor.Toolbar({appendTo: '#test'})

    it "throws an exception when invalid options are passed", ->
      expect(=> @toolbar.buildButton('foo', false)).toThrow('Unknown button structure -- please provide an array, object, or string for "foo".')

    it "returns false if the name is _custom, or _regions", ->
      expect(@toolbar.buildButton('_custom', 'foo')).toEqual(false)
      expect(@toolbar.buildButton('_regions', ['regiontype', 'another_regiontype'])).toEqual(false)

    it "builds buttons", ->
      html = $('<div>').html(@toolbar.buildButton('foobutton', ['title', 'summary', {}])).html()
      expect(html).toContain('title="summary"')
      expect(html).toContain('class="dc_editor-button dc_editor-foobutton-button"')
      expect(html).toContain('<em>title</em>')

    it "builds button groups", ->
      html = $('<div>').html(@toolbar.buildButton('foogroup', {foobutton: ['title', 'summary', {}]})).html()
      expect(html).toContain('class="dc_editor-button-group dc_editor-foogroup-group"')
      expect(html).toContain('title="summary"')
      expect(html).toContain('class="dc_editor-button dc_editor-foobutton-button"')
      expect(html).toContain('<em>title</em>')

    it "builds separators", ->
      html = $('<div>').html(@toolbar.buildButton('foosep1', ' ')).html()
      expect(html).toEqual('<hr class="dc_editor-separator">')

      html = $('<div>').html(@toolbar.buildButton('foosep1', '-')).html()
      expect(html).toEqual('<hr class="dc_editor-line-separator">')

    it "builds buttons from configuration", ->
      expect($('.dc_editor-primary-toolbar .dc_editor-save-button').length).toEqual(1)
      expect($('.dc_editor-primary-toolbar .dc_editor-preview-button').length).toEqual(1)

    it "builds button groups from configuration", ->
      expect($('.dc_editor-editable-toolbar .dc_editor-decoration-group').length).toEqual(1)
      expect($('.dc_editor-editable-toolbar .dc_editor-script-group').length).toEqual(1)

    it "builds separators from configuration", ->
      expect($('.dc_editor-separator').length).toBeGreaterThan(1);
      expect($('.dc_editor-line-separator').length).toBeGreaterThan(1);


  describe "observed events", ->

    beforeEach ->
      @toolbar = new DcEditor.Toolbar({appendTo: '#test'})

    describe "custom event: region:focused", ->

      it "enables toolbars based on the region type", ->
        $('.dc_editor-editable-toolbar').addClass('disabled')
        DcEditor.trigger('region:focused', {region: {type: 'editable'}})
        expect($('.dc_editor.editable-toolbar').hasClass('disabled')).toEqual(false)

        $('.dc_editor-editable-toolbar').addClass('disabled')
        DcEditor.trigger('region:focused', {region: {type: 'markupable'}})
        expect($('.dc_editor.editable-toolbar').hasClass('disabled')).toEqual(false)

    describe "custom event: region:blurred", ->

      it "disables toolbars for the region type", ->
        $('.dc_editor-editable-toolbar').removeClass('disabled')
        DcEditor.trigger('region:blurred', {region: {type: 'editable'}})
        expect($('.dc_editor-editable-toolbar').hasClass('disabled')).toEqual(true)

    describe "click", ->

      it "triggers hide:dialogs", ->
        spy = spyOn(DcEditor, 'trigger')

        jasmine.simulate.click(@toolbar.element.get(0))

        expect(spy.callCount).toEqual(1)
        expect(spy.argsForCall[0]).toEqual(['hide:dialogs'])


  describe "#height", ->

    beforeEach ->
      spyOn(DcEditor.Toolbar.prototype, 'buildButton').andCallFake(=> $('<div>'))
      spyOn(DcEditor.Toolbar.prototype, 'bindEvents').andCallFake(=>)

    describe "when visible", ->

      beforeEach ->
        @toolbar = new DcEditor.Toolbar({appendTo: '#test', visible: true})

      it "returns the element outerheight", ->
        expect(@toolbar.height()).toEqual($('.dc_editor-toolbar-container').outerHeight())

    describe "when not visible", ->

      beforeEach ->
        @toolbar = new DcEditor.Toolbar({appendTo: '#test', visible: false})

      it "returns 0", ->
        expect(@toolbar.height()).toEqual(0)


  describe "#show", ->

    beforeEach ->
      spyOn(DcEditor.Toolbar.prototype, 'buildButton').andCallFake(=> $('<div>'))
      spyOn(DcEditor.Toolbar.prototype, 'bindEvents').andCallFake(=>)
      @toolbar = new DcEditor.Toolbar({appendTo: '#test', visible: false})

    it "sets visible to true", ->
      @toolbar.visible = false
      @toolbar.show()
      expect(@toolbar.visible).toEqual(true)

    it "displays the element", ->
      $('.dc_editor-toolbar-container').css({display: 'none'})
      @toolbar.show()
      expect($('.dc_editor-toolbar-container').css('display')).toEqual('block')

    it "sets the top of the element", ->
      $('.dc_editor-toolbar-container').css({top: '-20px'})
      @toolbar.show()
      expect($('.dc_editor-toolbar-container').css('top')).toEqual('0px')


  describe "#hide", ->

    beforeEach ->
      spyOn(DcEditor.Toolbar.prototype, 'buildButton').andCallFake(=> $('<div>'))
      spyOn(DcEditor.Toolbar.prototype, 'bindEvents').andCallFake(=>)
      @toolbar = new DcEditor.Toolbar({appendTo: '#test', visible: true})

    it "sets visible to false", ->
      @toolbar.visible = true
      @toolbar.hide()
      expect(@toolbar.visible).toEqual(false)

    it "hides the element", ->
      $('.dc_editor-toolbar-container').css({display: 'block'})
      @toolbar.hide()
      expect($('.dc_editor-toolbar-container').css('display')).toEqual('none')
