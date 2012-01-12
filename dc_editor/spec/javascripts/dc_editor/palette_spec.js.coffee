describe "DcEditor.Palette", ->

  template 'dc_editor/palette.html'

  beforeEach ->
    $.fx.off = true

  afterEach ->
    @palette = null
    delete(@palette)

  describe "#build", ->

    it "builds an element", ->
      @palette = new DcEditor.Palette('/evergreen/responses/blank.html', 'foo', {appendTo: '#test', for: $('#button')})
      html = $('<div>').html(@palette.element).html()
      expect(html).toContain('class="dc_editor-palette dc_editor-foo-palette loading"')
      expect(html).toContain('style="display:none"')

    it "appends to any element", ->
      @palette = new DcEditor.Palette('/evergreen/responses/blank.html', 'foo', {appendTo: '#palette_container', for: $('#button')})
      expect($('#palette_container .dc_editor-palette').length).toEqual(1)


  describe "observed events", ->

    beforeEach ->
      @palette = new DcEditor.Palette('/evergreen/responses/blank.html', 'foo', {appendTo: '#test', for: $('#button')})

    it "hides", ->
      @palette.element.css({display: 'block'})
      DcEditor.trigger('hide:dialogs')
      expect(@palette.element.css('display')).toEqual('none')

    it "doesn't hide if it's the same dialog", ->
      @palette.element.css({display: 'block'})
      DcEditor.trigger('hide:dialogs', @palette)
      expect(@palette.element.css('display')).toEqual('block')


  describe "#position", ->

    beforeEach ->
      @palette = new DcEditor.Palette('/evergreen/responses/blank.html', 'foo', {appendTo: '#test', for: $('#button')})

    it "positions based on it's button", ->
      @palette.element.css({display: 'block'})
      @palette.position(true)
      expect(@palette.element.offset()).toEqual({top: 62, left: 42})
