describe "DcEditor.Region", ->

  template 'dc_editor/region.html'

  beforeEach ->
    DcEditor.config.regionClass = 'custom-region-class'

  afterEach ->
    @region = null
    delete(@region)
    $(window).unbind('dc_editor:mode')
    $(window).unbind('dc_editor:focus:frame')
    $(window).unbind('dc_editor:action')

  describe "constructor", ->

    beforeEach ->
      @buildSpy = spyOn(DcEditor.Region.prototype, 'build').andCallFake(=>)
      @bindEventsSpy = spyOn(DcEditor.Region.prototype, 'bindEvents').andCallFake(=>)
      @pushHistorySpy = spyOn(DcEditor.Region.prototype, 'pushHistory').andCallFake(=>)

    it "expects an element and window (for context)", ->
      @region = new DcEditor.Region($('#region'), window)
      expect(@region.element.get(0)).toEqual($('#region').get(0))

    it "accepts options", ->
      @region = new DcEditor.Region($('#region'), window, {foo: 'bar'})
      expect(@region.options).toEqual({foo: 'bar'})

    it "sets variables we need", ->
      @region = new DcEditor.Region($('#region'), window, {foo: 'bar'})
      expect(@region.name).toEqual('region')
      expect(@region.history).toBeDefined()

    it "calls build", ->
      @region = new DcEditor.Region($('#region'), window, {foo: 'bar'})
      expect(@buildSpy.callCount).toEqual(1)

    it "calls bindEvents", ->
      @region = new DcEditor.Region($('#region'), window, {foo: 'bar'})
      expect(@bindEventsSpy.callCount).toEqual(1)

    it "pushes the initial state to the history buffer", ->
      @region = new DcEditor.Region($('#region'), window, {foo: 'bar'})
      expect(@pushHistorySpy.callCount).toEqual(1)

    it "sets the instance of the region into data for the element", ->
      @region = new DcEditor.Region($('#region'), window, {foo: 'bar'})
      expect(@region.element.data('region')).toEqual(@region)


  describe "#build", ->

    it "does nothing and is there as an interface"


  describe "#focus", ->

    it "does nothing and is there as an interface"


  describe "observed events", ->

    beforeEach ->
      @region = new DcEditor.Region($('#region_with_snippet'), window)

    describe "custom event: mode", ->

      it "calls togglePreview if the mode is preview", ->
        spy = spyOn(DcEditor.Region.prototype, 'togglePreview').andCallFake(=>)
        DcEditor.trigger('mode', {mode: 'foo'})
        expect(spy.callCount).toEqual(0)
        DcEditor.trigger('mode', {mode: 'preview'})
        expect(spy.callCount).toEqual(1)

    describe "custom event: focus:frame", ->

      beforeEach ->
        @focusSpy = spyOn(DcEditor.Region.prototype, 'focus').andCallFake(=>)

      it "does nothing if in preview mode", ->
        @region.previewing = true
        DcEditor.trigger('focus:frame', {region: @region})
        expect(@focusSpy.callCount).toEqual(0)

      it "does nothing if it's not active region", ->
        DcEditor.region = {}
        DcEditor.trigger('focus:frame', {region: @region})
        expect(@focusSpy.callCount).toEqual(0)

      it "calls focus", ->
        DcEditor.region = @region
        DcEditor.trigger('focus:frame', {region: @region})
        expect(@focusSpy.callCount).toEqual(1)

    describe "custom event: action", ->

      beforeEach ->
        @execCommandSpy = spyOn(DcEditor.Region.prototype, 'execCommand').andCallFake(=>)

      it "does nothing if in preview mode", ->
        @region.previewing = true
        DcEditor.trigger('action', {action: 'foo', value: 'bar'})
        expect(@execCommandSpy.callCount).toEqual(0)

      it "does nothing if it's not active region", ->
        DcEditor.region = {}
        DcEditor.trigger('action', {action: 'foo', value: 'bar'})
        expect(@execCommandSpy.callCount).toEqual(0)

      it "calls execCommand with the action and options", ->
        DcEditor.region = @region
        DcEditor.trigger('action', {action: 'foo', value: 'bar'})
        expect(@execCommandSpy.callCount).toEqual(1)
        expect(@execCommandSpy.argsForCall[0]).toEqual(['foo', {action: 'foo', value: 'bar'}])

    describe "mouseover", ->

      beforeEach ->
        @triggerSpy = spyOn(DcEditor, 'trigger').andCallFake(=>)

      it "does nothing if in preview mode", ->
        @region.previewing = true
        jasmine.simulate.mousemove($('#region_with_snippet .dc_editor-snippet').get(0))
        expect(@triggerSpy.callCount).toEqual(0)

      it "does nothing if it's not the active region", ->
        DcEditor.region = {}
        jasmine.simulate.mousemove($('#region_with_snippet .dc_editor-snippet').get(0))
        expect(@triggerSpy.callCount).toEqual(0)

      it "shows the snippet toolbar if a snippet was moused over", ->
        DcEditor.region = @region
        jasmine.simulate.mousemove($('#region_with_snippet .dc_editor-snippet').get(0))
        expect(@triggerSpy.callCount).toEqual(1)
        expect(@triggerSpy.argsForCall[0][0]).toEqual('show:toolbar')

    describe "mouseout", ->

      beforeEach ->
        @triggerSpy = spyOn(DcEditor, 'trigger').andCallFake(=>)

      it "does nothing if previewing", ->
        @region.previewing = true
        jasmine.simulate.mouseout(@region.element.get(0))
        expect(@triggerSpy.callCount).toEqual(0)

      it "hides the snippet toolbar", ->
        jasmine.simulate.mouseout(@region.element.get(0))
        expect(@triggerSpy.callCount).toEqual(1)
        expect(@triggerSpy.argsForCall[0]).toEqual(['hide:toolbar', {type: 'snippet', immediately: false}])


  describe "#html", ->

    beforeEach ->
      @region = new DcEditor.Region($('#region_with_snippet'), window)

    describe "getting html", ->

      it "returns the html of the element", ->
        content = @region.content()
        expect(content).toEqual('contents<div class="dc_editor-snippet" data-snippet="snippet_1" data-version="1">snippet</div>')

      it "replaces snippet content with an indentifier if asked", ->
        content = @region.content(null, true)
        expect(content).toEqual('contents<div class="dc_editor-snippet" data-snippet="snippet_1">[snippet_1]</div>')

    describe "setting html", ->

      it "sets the value of the html", ->
        @region.content('new html')
        expect($('#region_with_snippet').html()).toEqual('new html')


  describe "#togglePreview", ->

    beforeEach ->
      @region = new DcEditor.Region($('#region'), window)
      DcEditor.region = @region
      @focusSpy = spyOn(DcEditor.Region.prototype, 'focus').andCallFake(=>)
      @triggerSpy = spyOn(DcEditor, 'trigger').andCallFake(=>)

    describe "when not previewing", ->

      beforeEach ->
        @region.togglePreview()

      it "sets previewing to true", ->
        expect(@region.previewing).toEqual(true)

      it "swaps classes on the element", ->
        expect(@region.element.hasClass('custom-region-class')).toEqual(false)
        expect(@region.element.hasClass('custom-region-class-preview')).toEqual(true)

      it "triggers a blur event", ->
        expect(@triggerSpy.callCount).toEqual(1)
        expect(@triggerSpy.argsForCall[0]).toEqual(['region:blurred', {region: @region}])

    describe "when previewing", ->

      beforeEach ->
        @region.previewing = true
        @region.togglePreview()

      it "sets previewing to false", ->
        expect(@region.previewing).toEqual(false)

      it "swaps classes on the element", ->
        expect(@region.element.hasClass('custom-region-class-preview')).toEqual(false)
        expect(@region.element.hasClass('custom-region-class')).toEqual(true)

      it "calls focus if it's the active region", ->
        expect(@focusSpy.callCount).toEqual(1)


  describe "#execCommand", ->

    beforeEach ->
      DcEditor.changes = false
      @region = new DcEditor.Region($('#region'), window)

    it "calls focus", ->
      spy = spyOn(DcEditor.Region.prototype, 'focus').andCallFake(=>)
      @region.execCommand('foo')
      expect(spy.callCount).toEqual(1)

    it "pushes to the history (unless the action is redo)", ->
      spy = spyOn(DcEditor.Region.prototype, 'pushHistory').andCallFake(=>)
      @region.execCommand('redo')
      expect(spy.callCount).toEqual(0)
      @region.execCommand('foo')
      expect(spy.callCount).toEqual(1)

    it "tells DcEditor that changes have been made", ->
      @region.execCommand('foo')
      expect(DcEditor.changes).toEqual(true)


  describe "#pushHistory", ->

    beforeEach ->
      DcEditor.changes = false
      @region = new DcEditor.Region($('#region'), window)

    it "pushes the current content (html) of the region to the history buffer", ->
      spy = spyOn(@region.history, 'push').andCallFake(=>)
      @region.pushHistory('foo')
      expect(spy.callCount).toEqual(1)


  describe "#snippets", ->

    it "does nothing and is there as an interface", ->


  describe "#serialize", ->

    beforeEach ->
      @region = new DcEditor.Region($('#region'), window)

    it "returns an object with it's type, value, and snippets", ->
      serialized = @region.serialize()
      expect(serialized.type).toEqual('region')
      expect(serialized.value).toEqual('contents')
      expect(serialized.snippets).toEqual({})