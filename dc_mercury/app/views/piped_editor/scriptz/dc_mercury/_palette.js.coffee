class @DcMercury.Palette extends DcMercury.Dialog

  constructor: (@url, @name, @options = {}) ->
    super


  build: ->
    @element = jQuery('<div>', {class: "dc_mercury-palette dc_mercury-#{@name}-palette loading", style: 'display:none'})
    @element.appendTo(jQuery(@options.appendTo).get(0) ? 'body')


  bindEvents: ->
    DcMercury.on 'hide:dialogs', (event, dialog) => @hide() unless dialog == @
    super


  position: (keepVisible) ->
    @element.css({top: 0, left: 0, display: 'block', visibility: 'hidden'})
    position = @button.offset()
    width = @element.width()

    position.left = position.left - width + @button.width() if position.left + width > jQuery(window).width()

    @element.css {
      top: position.top + @button.height()
      left: position.left
      display: if keepVisible then 'block' else 'none'
      visibility: 'visible'
    }
