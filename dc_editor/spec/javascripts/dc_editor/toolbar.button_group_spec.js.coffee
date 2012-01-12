describe "DcEditor.Toolbar.ButtonGroup", ->

  template 'dc_editor/toolbar.button_group.html'

  beforeEach ->
    DcEditor.Toolbar.ButtonGroup.contexts.foo = -> false
    @region = {
      element: $('<div class="dc_editor-region">')
      currentElement: -> $('<div>')
    }

  afterEach ->
    @buttonGroup = null
    delete(@buttonGroup)
    $(window).unbind('dc_editor:region:update')

  describe "constructor", ->

    beforeEach ->
      @buildSpy = spyOn(DcEditor.Toolbar.ButtonGroup.prototype, 'build').andCallThrough()
      @bindEventsSpy = spyOn(DcEditor.Toolbar.ButtonGroup.prototype, 'bindEvents').andCallThrough()
      @buttonGroup = new DcEditor.Toolbar.ButtonGroup('foo', {_context: true})

    it "returns an element", ->
      html = $('<div>').html(@buttonGroup).html()
      expect(html).toEqual('<div class="dc_editor-button-group dc_editor-foo-group disabled"></div>')

    it "calls build", ->
      expect(@buildSpy.callCount).toEqual(1)

    it "calls bindEvents", ->
      expect(@bindEventsSpy.callCount).toEqual(1)


  describe "observed events", ->

    describe "custom event: region:update", ->

      it "sets disabled/enabled state based on it's context", ->
        @buttonGroup = new DcEditor.Toolbar.ButtonGroup('foo', {_context: true})
        contextSpy = spyOn(DcEditor.Toolbar.ButtonGroup.contexts, 'foo').andCallFake(-> true)

        expect(@buttonGroup.hasClass('disabled')).toEqual(true)

        DcEditor.trigger('region:update', {region: @region})
        expect(contextSpy.callCount).toEqual(1)
        expect(@buttonGroup.hasClass('disabled')).toEqual(false)

    describe "custom event: region:focused", ->

      beforeEach ->
        @region = {
          type: 'editable'
          element: $('<div class="dc_editor-region">')
        }

      it "disables if the region type isn't supported", ->
        @buttonGroup = new DcEditor.Toolbar.ButtonGroup('foo', {_regions: ['foo']})
        @buttonGroup.removeClass('disabled')
        DcEditor.trigger('region:focused', {region: @region})
        expect(@buttonGroup.hasClass('disabled')).toEqual(true)

      it "enables if the region type is supported", ->
        @buttonGroup = new DcEditor.Toolbar.ButtonGroup('foo', {_regions: ['editable']})
        @buttonGroup.addClass('disabled')
        DcEditor.trigger('region:focused', {region: @region})
        expect(@buttonGroup.hasClass('disabled')).toEqual(false)

    describe "custom event: region:blurred", ->

      it "disables if it's a button group for specific region types", ->
        @buttonGroup = new DcEditor.Toolbar.ButtonGroup('foo', {_regions: ['editable']})
        @buttonGroup.removeClass('disabled')
        DcEditor.trigger('region:blurred', {region: @region})



describe "DcEditor.Toolbar.ButtonGroup.contexts", ->

  template 'dc_editor/toolbar.button_group.html'

  beforeEach ->
    @contexts = DcEditor.Toolbar.ButtonGroup.contexts
    @region = $('#context_container')

  describe "table", ->

    it "looks up for a table tag", ->
      expect(@contexts.table($('#context_td'), @region)).toEqual(true)
      expect(@contexts.table($('#context_em'), @region)).toEqual(false)
