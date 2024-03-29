class @DcMercury.Panel extends DcMercury.Dialog

  constructor: (@url, @name, @options = {}) ->
    super


  build: ->
    @element = jQuery('<div>', {class: 'dc_mercury-panel loading', style: 'display:none;'})
    @titleElement = jQuery("<h1>#{DcMercury.I18n(@options.title)}</h1>").appendTo(@element)
    @paneElement = jQuery('<div>', {class: 'dc_mercury-panel-pane'}).appendTo(@element)

    if @options.closeButton
      jQuery('<a/>', {class: 'dc_mercury-panel-close'}).appendTo(@titleElement).css({opacity: 0})

    @element.appendTo(jQuery(@options.appendTo).get(0) ? 'body')


  bindEvents: ->
    DcMercury.on 'resize', => @position(@visible)

    DcMercury.on 'hide:panels', (event, panel) =>
      return if panel == @
      @button.removeClass('pressed')
      @hide()

    @titleElement.find('.dc_mercury-panel-close').on 'click', (event) ->
      event.preventDefault()
      DcMercury.trigger('hide:panels')

    @element.on 'mousedown', (event) ->
      event.stopPropagation()

    @element.on 'ajax:beforeSend', (event, xhr, options) =>
      options.success = (content) =>
        @loadContent(content)
        @resize()

    super


  show: ->
    DcMercury.trigger('hide:panels', @)
    super


  resize: ->
    @titleElement.find('.dc_mercury-panel-close').css({opacity: 0})
    @paneElement.css({display: 'none'})
    preWidth = @element.width()

    @paneElement.css({visibility: 'hidden', width: 'auto', display: 'block'})
    postWidth = @element.width()

    @paneElement.css({visibility: 'visible', display: 'none'})
    position = @element.offset()
    @element.animate {left: position.left - (postWidth - preWidth), width: postWidth}, 200, 'easeInOutSine', =>
      @titleElement.find('.dc_mercury-panel-close').animate({opacity: 1}, 100)

      @paneElement.css({display: 'block', width: postWidth})
      @makeDraggable()

    @hide() unless @visible


  position: (keepVisible) ->
    @element.css({display: 'block', visibility: 'hidden'})
    offset = @element.offset()
    elementWidth = @element.width()
    height = DcMercury.displayRect.height - 16

    paneHeight = height - @titleElement.outerHeight()
    @paneElement.css({height: paneHeight, overflowY: if paneHeight < 30 then 'hidden' else 'auto'})

    left = DcMercury.displayRect.width - elementWidth - 20 unless @moved
    left = 8 if left <= 8

    if @pinned || elementWidth + offset.left > DcMercury.displayRect.width - 20
      left = DcMercury.displayRect.width - elementWidth - 20

    @element.css {
      top: DcMercury.displayRect.top + 8,
      left: left,
      height: height,
      display: if keepVisible then 'block' else 'none',
      visibility: 'visible'
    }

    @makeDraggable()
    @element.hide() unless keepVisible


  loadContent: (data) ->
    @loaded = true
    @element.removeClass('loading')
    @paneElement.css({visibility: 'hidden'})
    @paneElement.html(data)
    @paneElement.localize(DcMercury.locale()) if DcMercury.config.localization.enabled


  makeDraggable: ->
    elementWidth = @element.width()
    @element.draggable {
      handle: 'h1',
      axis: 'x',
      opacity: 0.70
      scroll: false,
      addClasses: false,
      iframeFix: true,
      containment: [8, 0, DcMercury.displayRect.width - elementWidth - 20, 0]  #[x1, y1, x2, y2]
      stop: =>
        left = @element.offset().left
        @moved = true
        @pinned = if left > DcMercury.displayRect.width - elementWidth - 30 then true else false
        return true
    }
