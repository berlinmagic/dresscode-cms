@DcEditor.lightview = (url, options = {}) ->
  DcEditor.lightview.show(url, options)
  return DcEditor.lightview

jQuery.extend DcEditor.lightview,
  minWidth: 400

  show: (@url, @options = {}) ->
    DcEditor.trigger('focus:window')
    @initialize()
    if @visible then @update() else @appear()


  initialize: ->
    return if @initialized
    @build()
    @bindEvents()
    @initialized = true


  build: ->
    @element = jQuery('<div>', {class: 'dc_editor-lightview loading'})
    @element.html('<h1 class="dc_editor-lightview-title"><span></span></h1>')
    @element.append('<div class="dc_editor-lightview-content"></div>')

    @overlay = jQuery('<div>', {class: 'dc_editor-lightview-overlay'})

    @titleElement = @element.find('.dc_editor-lightview-title')
    @titleElement.append('<a class="dc_editor-lightview-close"></a>') if @options.closeButton

    @contentElement = @element.find('.dc_editor-lightview-content')

    @element.appendTo(jQuery(@options.appendTo).get(0) ? 'body')
    @overlay.appendTo(jQuery(@options.appendTo).get(0) ? 'body')


  bindEvents: ->
    DcEditor.on 'refresh', => @resize(true)
    DcEditor.on 'resize', => @position() if @visible

    @overlay.on 'click', =>
      @hide() unless @options.closeButton

    @titleElement.find('.dc_editor-lightview-close').on 'click', =>
      @hide()

    @element.on 'ajax:beforeSend', (event, xhr, options) =>
      options.success = (content) =>
        @loadContent(content)

    jQuery(document).on 'keydown', (event) =>
       @hide() if event.keyCode == 27 && @visible


  appear: ->
    @showing = true
    @position()

    @overlay.show().css({opacity: 0})
    @overlay.animate {opacity: 1}, 200, 'easeInOutSine', =>
      @setTitle()
      @element.show().css({opacity: 0})
      @element.stop().animate {opacity: 1}, 200, 'easeInOutSine', =>
        @visible = true
        @showing = false
        @load()


  resize: (keepVisible) ->
    visibility = if keepVisible then 'visible' else 'hidden'

    viewportWidth = DcEditor.displayRect.width
    viewportHeight = DcEditor.displayRect.fullHeight

    titleHeight = @titleElement.outerHeight()

    width = @contentElement.outerWidth()
    width = viewportWidth - 40 if width > viewportWidth - 40 || @options.fullSize

    @contentPane.css({height: 'auto'}) if @contentPane
    @contentElement.css({height: 'auto', visibility: visibility, display: 'block'})

    height = @contentElement.outerHeight() + titleHeight
    height = viewportHeight - 20 if height > viewportHeight - 20 || @options.fullSize

    width = 300 if width < 300
    height = 150 if height < 150

    @element.stop().animate {top: ((viewportHeight - height) / 2) + 10, left: (DcEditor.displayRect.width - width) / 2, width: width, height: height}, 200, 'easeInOutSine', =>
      @contentElement.css({visibility: 'visible', display: 'block'})
      if @contentPane.length
        @contentElement.css({height: height - titleHeight, overflow: 'visible'})
        controlHeight = if @contentControl.length then @contentControl.outerHeight() else 0
        @contentPane.css({height: height - titleHeight - controlHeight - 40})
        @contentPane.find('.dc_editor-display-pane').css({width: width - 40})
      else
        @contentElement.css({height: height - titleHeight - 30, overflow: 'auto'})


  position: ->
    viewportWidth = DcEditor.displayRect.width
    viewportHeight = DcEditor.displayRect.fullHeight

    @contentPane.css({height: 'auto'}) if @contentPane
    @contentElement.css({height: 'auto'})
    @element.css({width: 'auto', height: 'auto', display: 'block', visibility: 'hidden'})

    width = @contentElement.width() + 40
    height = @contentElement.height() + @titleElement.outerHeight() + 30

    width = viewportWidth - 40 if width > viewportWidth - 40 || @options.fullSize
    height = viewportHeight - 20 if height > viewportHeight - 20 || @options.fullSize

    width = 300 if width < 300
    height = 150 if height < 150

    titleHeight = @titleElement.outerHeight()
    if @contentPane && @contentPane.length
      @contentElement.css({height: height - titleHeight, overflow: 'visible'})
      controlHeight = if @contentControl.length then @contentControl.outerHeight() else 0
      @contentPane.css({height: height - titleHeight - controlHeight - 40})
      @contentPane.find('.dc_editor-display-pane').css({width: width - 40})
    else
      @contentElement.css({height: height - titleHeight - 30, overflow: 'auto'})

    @element.css {
      top: ((viewportHeight - height) / 2) + 10,
      left: (viewportWidth - width) / 2,
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
    if DcEditor.preloadedViews[@url]
      setTimeout(10, => @loadContent(DcEditor.preloadedViews[@url]))
    else
      jQuery.ajax @url, {
        headers: DcEditor.ajaxHeaders()
        type: @options.loadType || 'GET'
        data: @options.loadData
        success: (data) => @loadContent(data)
        error: =>
          @hide()
          DcEditor.notify('DcEditor was unable to load %s for the lightview.', @url)
      }


  loadContent: (data, options = null) ->
    @initialize()
    @options = options || @options
    @setTitle()
    @loaded = true
    @element.removeClass('loading')
    @contentElement.html(data)
    @contentElement.css({display: 'none', visibility: 'hidden'})

    # for complex lightview content, we provide panes and controls
    @contentPane = @element.find('.dc_editor-display-pane-container')
    @contentControl = @element.find('.dc_editor-display-controls')

    @options.afterLoad.call(@) if @options.afterLoad
    if @options.handler
      if DcEditor.modalHandlers[@options.handler]
        DcEditor.modalHandlers[@options.handler].call(@)
      else if DcEditor.lightviewHandlers[@options.handler]
        DcEditor.lightviewHandlers[@options.handler].call(@)

    @element.localize(DcEditor.locale()) if DcEditor.config.localization.enabled
    @resize()


  setTitle: ->
    @titleElement.find('span').html(DcEditor.I18n(@options.title))


  reset: ->
    @titleElement.find('span').html('')
    @contentElement.html('')


  hide: ->
    return if @showing
    @options = {}
    @initialized = false

    DcEditor.trigger('focus:frame')
    @element.hide()
    @overlay.hide()
    @reset()

    @visible = false
