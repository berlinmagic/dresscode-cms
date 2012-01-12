describe "DcEditor.Toolbar.Expander", ->

  template 'dc_editor/toolbar.expander.html'

  beforeEach ->
    @container = $('#expander_container')

  afterEach ->
    @expander = null
    delete(@expander)
    $(window).unbind('dc_editor:resize')

  describe "constructor", ->

    beforeEach ->
      @expander = new DcEditor.Toolbar.Expander('foo', {appendTo: '#test', for: @container})

    it "expects a name, and options", ->
      html = $('<div>').html(@expander).html()
      expect(html).toContain('class="dc_editor-palette dc_editor-expander dc_editor-foo-expander"')
      expect(html).toMatch(/style="display:\s?none/)
      expect($('#test .dc_editor-toolbar-expander').length).toEqual(1)


  describe "#build", ->

    beforeEach ->
      @resizeSpy = spyOn(DcEditor.Toolbar.Expander.prototype, 'windowResize').andCallFake(=>)
      @expander = new DcEditor.Toolbar.Expander('foo', {appendTo: '#test', for: @container})

    it "sets the whitespace of the container to normal", ->
      expect(@container.css('whiteSpace')).toEqual('normal')

    it "builds an element", ->
      html = $('<div>').html(@expander).html()
      expect(html).toContain('class="dc_editor-palette dc_editor-expander dc_editor-foo-expander"')
      expect(html).toMatch(/style="display:\s?none/)

    it "builds a trigger button", ->
      expect($('#test .dc_editor-toolbar-expander').length).toEqual(1)

    it "calls windowResize", ->
      expect(@resizeSpy.callCount).toEqual(1)


  describe "observed events", ->

    beforeEach ->
      $('.dc_editor-button').data('expander', '<div data-button="test">expander</div>')
      @expander = new DcEditor.Toolbar.Expander('foo', {appendTo: '#test', for: @container})

    describe "custom event: hide:dialogs", ->

      it "hides", ->
        @expander.css({display: 'block'})
        DcEditor.trigger('hide:dialogs')
        expect(@expander.css('display')).toEqual('none')

      it "doesn't hide if it's the same dialog", ->
        # there's no way to test this since we don't expose the instance -- just the element
        #@expander.css({display: 'block'})
        #DcEditor.trigger('hide:dialogs', !instance!)
        #expect(@expander.css('display')).toEqual('block')

    describe "custom event: resize", ->

      it "calls windowResize", ->
        spy = spyOn(DcEditor.Toolbar.Expander.prototype, 'windowResize').andCallFake(=>)
        DcEditor.trigger('resize')
        expect(spy.callCount).toEqual(1)

    describe "click (on trigger)", ->

      it "pulls buttons into the palette", ->
        jasmine.simulate.click($('.dc_editor-toolbar-expander').get(0))
        expect(@expander.html()).toEqual('<div data-button="test">expander</div>')

    describe "click", ->

      it "calls click on the real button", ->
        button = $('#button2')
        spy = spyOn(button, 'click').andCallFake(=>)
        @container.find = -> button
        @expander.appendTo('#test')

        jasmine.simulate.click($('.dc_editor-toolbar-expander').get(0))
        jasmine.simulate.click($('[data-button=test]').get(0))
        expect(spy.callCount).toEqual(1)

  describe "#windowResize", ->

    it "hides", ->
      @expander = new DcEditor.Toolbar.Expander('foo', {appendTo: '#test', for: @container})
      @expander.css({display: 'block'})

      DcEditor.trigger('resize')
      expect(@expander.css('display')).toEqual('none')

    it "shows the trigger if the container is wider than the window", ->
      @expander = new DcEditor.Toolbar.Expander('foo', {appendTo: '#test', for: @container})
      DcEditor.trigger('resize')
      expect($('.dc_editor-toolbar-expander').css('display')).toEqual('block')

    it "hides the trigger if the container is narrower than the window", ->
      @container.css({width: '1px'})
      @expander = new DcEditor.Toolbar.Expander('foo', {appendTo: '#test', for: @container})
      DcEditor.trigger('resize')
      expect($('.dc_editor-toolbar-expander').css('display')).toEqual('none')


  describe "#position", ->

    it "positions the element", ->
      @expander = new DcEditor.Toolbar.Expander('foo', {appendTo: '#test', for: @container})
      @expander.appendTo('#positioned_container')
      jasmine.simulate.click($('.dc_editor-toolbar-expander').get(0))

      expect(@expander.offset()).toEqual({top: 42, left: 42})
