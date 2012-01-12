describe "DcEditor.Select", ->

  template 'dc_editor/select.html'

  beforeEach ->
    $.fx.off = true

  afterEach ->
    @select = null
    delete(@select)

  describe "#build", ->

    it "builds an element", ->
      @select = new DcEditor.Select('/evergreen/responses/blank.html', 'foo', {appendTo: '#test', for: $('#button')})
      html = $('<div>').html(@select.element).html()
      expect(html).toContain('class="dc_editor-select dc_editor-foo-select loading"')
      expect(html).toContain('style="display:none"')

    it "appends to any element", ->
      @select = new DcEditor.Select('/evergreen/responses/blank.html', 'foo', {appendTo: '#select_container', for: $('#button')})
      expect($('#select_container .dc_editor-select').length).toEqual(1)


  describe "observed events", ->

    beforeEach ->
      @select = new DcEditor.Select('/evergreen/responses/blank.html', 'foo', {appendTo: '#test', for: $('#button')})

    it "hides", ->
      @select.element.css({display: 'block'})
      DcEditor.trigger('hide:dialogs')
      expect(@select.element.css('display')).toEqual('none')

    it "doesn't hide if it's the same dialog", ->
      @select.element.css({display: 'block'})
      DcEditor.trigger('hide:dialogs', @select)
      expect(@select.element.css('display')).toEqual('block')


  describe "#position", ->

    beforeEach ->
      @select = new DcEditor.Select('/evergreen/responses/blank.html', 'foo', {appendTo: '#test', for: $('#button')})

    it "positions based on it's button", ->
      @select.element.css({display: 'block'})
      @select.position(true)
      expect(@select.element.offset()).toEqual({top: 20, left: 42})
