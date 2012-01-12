class @DcEditor.Toolbar.Expander extends DcEditor.Palette

  constructor: (@name, @options) ->
    @container = @options.for
    @containerWidth = @container.outerWidth()
    super(null, @name, @options)
    return @element


  build: ->
    @container.css({whiteSpace: 'normal'})
    @trigger = jQuery('<div>', {class: 'dc_editor-toolbar-expander'}).appendTo(jQuery(@options.appendTo).get(0) ? 'body')
    @element = jQuery('<div>', {class: "dc_editor-palette dc_editor-expander dc_editor-#{@name}-expander", style: 'display:none'})
    @windowResize()


  bindEvents: ->
    DcEditor.on 'hide:dialogs', (event, dialog) => @hide() unless dialog == @
    DcEditor.on 'resize', => @windowResize()

    super

    @trigger.click (event) =>
      event.stopPropagation()
      hiddenButtons = []
      for button in @container.find('.dc_editor-button')
        button = jQuery(button)
        hiddenButtons.push(button.data('expander')) if button.position().top > 5

      @loadContent(hiddenButtons.join(''))
      @toggle()

    @element.click (event) =>
      buttonName = jQuery(event.target).closest('[data-button]').data('button')
      button = @container.find(".dc_editor-#{buttonName}-button")
      button.click()


  windowResize: ->
    if @containerWidth > jQuery(window).width() then @trigger.show() else @trigger.hide()
    @hide()


  position: (keepVisible) ->
    @element.css({top: 0, left: 0, display: 'block', visibility: 'hidden'})
    position = @trigger.offset()
    width = @element.width()

    position.left = position.left - width + @trigger.width() if position.left + width > jQuery(window).width()

    @element.css {
      top: position.top + @trigger.height()
      left: position.left
      display: if keepVisible then 'block' else 'none'
      visibility: 'visible'
    }
