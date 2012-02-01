@DcMercury.modal = (url, options = {}) ->
  DcMercury.modal.show(url, options)
  return DcMercury.modal

jQuery.extend DcMercury.modal,
  minWidth: 400

  show: (@url, @options = {}) ->
    DcMercury.trigger('focus:window')
    @initialize()
    if @visible then @update() else @appear()
    if @options.content
      setTimeout 500, => @loadContent(@options.content)


  initialize: ->
    return if @initialized
    @build()
    @bindEvents()
    @initialized = true


  build: ->
    @element = jQuery('<div>', {class: 'dc_mercury-modal loading'})
    @element.html('<h1 class="dc_mercury-modal-title"><span></span><a>&times;</a></h1>')
    @element.append('<div class="dc_mercury-modal-content-container"><div class="dc_mercury-modal-content"></div></div>')

    @overlay = jQuery('<div>', {class: 'dc_mercury-modal-overlay'})

    @titleElement = @element.find('.dc_mercury-modal-title')
    @contentContainerElement = @element.find('.dc_mercury-modal-content-container')

    @contentElement = @element.find('.dc_mercury-modal-content')

    @element.appendTo(jQuery(@options.appendTo).get(0) ? 'body')
    @overlay.appendTo(jQuery(@options.appendTo).get(0) ? 'body')


  bindEvents: ->
    DcMercury.on 'refresh', => @resize(true)
    DcMercury.on 'resize', => @position()

    @overlay.on 'click', =>
      @hide() if @options.allowHideUsingOverlay

    @titleElement.find('a').on 'click', =>
      @hide()

    @element.on 'ajax:beforeSend', (event, xhr, options) =>
      options.success = (content) =>
        @loadContent(content)

    jQuery(document).on 'keydown', (event) =>
       @hide() if event.keyCode == 27 && @visible


  appear: ->
    @showing = true
    @position()

    @overlay.show()
    @overlay.animate {opacity: 1}, 200, 'easeInOutSine', =>
      @element.css({top: -@element.height()})
      @setTitle()
      @element.show()
      @element.animate {top: 0}, 200, 'easeInOutSine', =>
        @visible = true
        @showing = false
        @load()


  resize: (keepVisible) ->
    visibility = if keepVisible then 'visible' else 'hidden'

    titleHeight = @titleElement.outerHeight()

    width = @contentElement.outerWidth()

    @contentPane.css({height: 'auto'}) if @contentPane
    @contentElement.css({height: 'auto', visibility: visibility, display: 'block'})

    height = @contentElement.outerHeight() + titleHeight

    width = @minWidth if width < @minWidth
    height = DcMercury.displayRect.fullHeight - 20 if height > DcMercury.displayRect.fullHeight - 20 || @options.fullHeight

    @element.stop().animate {left: (DcMercury.displayRect.width - width) / 2, width: width, height: height}, 200, 'easeInOutSine', =>
      @contentElement.css({visibility: 'visible', display: 'block'})
      if @contentPane.length
        @contentElement.css({height: height - titleHeight, overflow: 'visible'})
        controlHeight = if @contentControl.length then @contentControl.outerHeight() else 0
        @contentPane.css({height: height - titleHeight - controlHeight - 40})
        @contentPane.find('.dc_mercury-display-pane').css({width: width - 40})
      else
        @contentElement.css({height: height - titleHeight, overflow: 'auto'})


  position: ->
    viewportWidth = DcMercury.displayRect.width

    @contentPane.css({height: 'auto'}) if @contentPane
    @contentElement.css({height: 'auto'})
    @element.css({width: 'auto', height: 'auto', display: 'block', visibility: 'hidden'})

    width = @element.width()
    height = @element.height()

    width = @minWidth if width < @minWidth
    height = DcMercury.displayRect.fullHeight - 20 if height > DcMercury.displayRect.fullHeight - 20 || @options.fullHeight

    titleHeight = @titleElement.outerHeight()
    if @contentPane && @contentPane.length
      @contentElement.css({height: height - titleHeight, overflow: 'visible'})
      controlHeight = if @contentControl.length then @contentControl.outerHeight() else 0
      @contentPane.css({height: height - titleHeight - controlHeight - 40})
      @contentPane.find('.dc_mercury-display-pane').css({width: width - 40})
    else
      @contentElement.css({height: height - titleHeight, overflow: 'auto'})

    @element.css {
      left: (viewportWidth - width) / 2
      width: width
      height: height
      display: if @visible then 'block' else 'none'
      visibility: 'visible'
    }


  update:  ->
    @reset()
    @resize()
    @load()


  load: ->
    @setTitle()
    return unless @url
    @element.addClass('loading')
    if DcMercury.preloadedViews[@url]
      setTimeout(10, => @loadContent(DcMercury.preloadedViews[@url]))
    else
      jQuery.ajax @url, {
        headers: DcMercury.ajaxHeaders()
        type: @options.loadType || 'GET'
        data: @options.loadData
        success: (data) => @loadContent(data)
        error: =>
          @hide()
          DcMercury.notify("DcMercury was unable to load %s for the modal.", @url)
      }


  loadContent: (data, options = null) ->
    @initialize()
    @options = options || @options
    @setTitle()
    @loaded = true
    @element.removeClass('loading')
    @contentElement.html(data)
    @contentElement.css({display: 'none', visibility: 'hidden'})

    # for complex modal content, we provide panes and controls
    @contentPane = @element.find('.dc_mercury-display-pane-container')
    @contentControl = @element.find('.dc_mercury-display-controls')

    @options.afterLoad.call(@) if @options.afterLoad
    if @options.handler
      if DcMercury.modalHandlers[@options.handler]
        DcMercury.modalHandlers[@options.handler].call(@)
      else if DcMercury.lightviewHandlers[@options.handler]
        DcMercury.lightviewHandlers[@options.handler].call(@)

    @element.localize(DcMercury.locale()) if DcMercury.config.localization.enabled
    @resize()


  setTitle: ->
    @titleElement.find('span').html(DcMercury.I18n(@options.title))
    closeButton = @titleElement.find('a')
    if @options.closeButton == false then closeButton.hide() else closeButton.show()


  reset: ->
    @titleElement.find('span').html('')
    @contentElement.html('')


  hide: ->
    return if @showing
    @options = {}
    @initialized = false

    DcMercury.trigger('focus:frame')
    @element.hide()
    @overlay.hide()
    @reset()

    @visible = false
