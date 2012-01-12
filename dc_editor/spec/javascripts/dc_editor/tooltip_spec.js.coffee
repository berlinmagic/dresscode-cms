describe "DcEditor.tooltip", ->

  template 'dc_editor/tooltip.html'

  beforeEach ->
    @forElement = $('#for_element')
    $.fx.off = true

  afterEach ->
    DcEditor.tooltip.visible = false
    DcEditor.tooltip.initialized = false

  describe "singleton method", ->

    beforeEach ->
      @showSpy = spyOn(DcEditor.tooltip, 'show').andCallFake(=>)

    it "calls show", ->
      DcEditor.tooltip()
      expect(@showSpy.callCount).toEqual(1)

    it "returns the function object", ->
      ret = DcEditor.tooltip()
      expect(ret).toEqual(DcEditor.tooltip)


  describe "#show", ->

    beforeEach ->
      @initializeSpy = spyOn(DcEditor.tooltip, 'initialize').andCallFake(=>)
      @updateSpy = spyOn(DcEditor.tooltip, 'update').andCallFake(=>)
      @appearSpy = spyOn(DcEditor.tooltip, 'appear').andCallFake(=>)

    it "gets the document from the element passed in", ->
      DcEditor.tooltip.show(@forElement, 'content')
      expect(DcEditor.tooltip.document).toEqual(document)

    it "calls initialize", ->
      DcEditor.tooltip.show(@forElement, 'content')
      expect(@initializeSpy.callCount).toEqual(1)

    describe "if visible", ->

      beforeEach ->
        DcEditor.tooltip.visible = true

      it "calls update", ->
        DcEditor.tooltip.show(@forElement, 'content')
        expect(@updateSpy.callCount).toEqual(1)

    describe "if not visible", ->

      beforeEach ->
        DcEditor.tooltip.visible = false

      it "calls appear", ->
        DcEditor.tooltip.show(@forElement, 'content')
        expect(@appearSpy.callCount).toEqual(1)


  describe "#initialize", ->

    it "calls build", ->
      spy = spyOn(DcEditor.tooltip, 'build').andCallFake(=>)
      spyOn(DcEditor.tooltip, 'bindEvents').andCallFake(=>)
      DcEditor.tooltip.initialize()
      expect(spy.callCount).toEqual(1)

    it "calls bindEvents", ->
      spy = spyOn(DcEditor.tooltip, 'bindEvents').andCallFake(=>)
      DcEditor.tooltip.initialize()
      expect(spy.callCount).toEqual(1)

    it "sets initialized to true", ->
      DcEditor.tooltip.initialize()
      expect(DcEditor.tooltip.initialized).toEqual(true)

    it "does nothing if already initialized", ->
      spy = spyOn(DcEditor.tooltip, 'bindEvents').andCallFake(=>)
      DcEditor.tooltip.initialized = true
      DcEditor.tooltip.initialize()
      expect(spy.callCount).toEqual(0)


  describe "#build", ->

    it "builds an element", ->
      DcEditor.tooltip.build()
      html = $('<div>').html(DcEditor.tooltip.element).html()
      expect(html).toContain('class="dc_editor-tooltip"')

    it "can append to any element", ->
      DcEditor.tooltip.options = {appendTo: '#tooltip_container'}
      DcEditor.tooltip.build()
      expect($('#tooltip_container').html()).toContain('class="dc_editor-tooltip"')


  describe "observed events", ->

    describe "custom event: resize", ->

      it "call position if visible", ->
        DcEditor.tooltip.visible = true
        spy = spyOn(DcEditor.tooltip, 'position').andCallFake(=>)
        DcEditor.trigger('resize')
        expect(spy.callCount).toEqual(1)

        DcEditor.tooltip.visible = false
        DcEditor.trigger('resize')
        expect(spy.callCount).toEqual(1)

    describe "document scrolling", ->

      # untestable
      it "calls position if visible", ->

    describe "element mousedown", ->

      # untestable
      it "stops the event", ->


  describe "#appear", ->

    beforeEach ->
      DcEditor.tooltip.build()
      @updateSpy = spyOn(DcEditor.tooltip, 'update').andCallFake(=>)

    it "calls update", ->
      DcEditor.tooltip.appear()
      expect(@updateSpy.callCount).toEqual(1)

    it "shows the element", ->
      DcEditor.tooltip.appear()
      expect(DcEditor.tooltip.element.css('display')).toEqual('block')
      expect(DcEditor.tooltip.element.css('opacity')).toEqual('1')

    it "sets visible to true", ->
      DcEditor.tooltip.visible = false
      DcEditor.tooltip.appear()
      expect(DcEditor.tooltip.visible).toEqual(true)


  describe "#update", ->

    beforeEach ->
      DcEditor.tooltip.build()
      @positionSpy = spyOn(DcEditor.tooltip, 'position').andCallFake(=>)

    it "sets the html", ->
      DcEditor.tooltip.content = 'foo'
      DcEditor.tooltip.update()
      expect(DcEditor.tooltip.element.html()).toEqual('foo')

    it "calls position", ->
      DcEditor.tooltip.update()
      expect(@positionSpy.callCount).toEqual(1)


  describe "#position", ->

    beforeEach ->
      DcEditor.tooltip.build()
      DcEditor.displayRect = {top: 0, left: 0, width: 200, height: 200}

    it "positions based on the element we're showing for", ->
      DcEditor.tooltip.forElement = @forElement
      DcEditor.tooltip.position()
      expect(DcEditor.tooltip.element.offset()).toEqual({top: 20 + @forElement.outerHeight(), left: 42})


  describe "#hide", ->

    beforeEach ->
      DcEditor.tooltip.build()
      DcEditor.tooltip.initialized = true

    it "hides the element", ->
      DcEditor.tooltip.element.css({display: 'block'})
      DcEditor.tooltip.hide()
      expect(DcEditor.tooltip.element.css('display')).toEqual('none')

    it "sets visible to false", ->
      DcEditor.tooltip.visible = true
      DcEditor.tooltip.hide()
      expect(DcEditor.tooltip.visible).toEqual(false)
