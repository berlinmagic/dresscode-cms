@DcEditor.modal = (url, options = {}) ->
  DcEditor.modal.show(url, options)
  return DcEditor.modal

jQuery.extend DcEditor.modal,
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
    @element = jQuery('<div>', {class: 'dc_editor-modal loading'})
    @element.html('<h1 class="dc_editor-modal-title"><span></span><a>&times;</a></h1>')
    @element.append('<div class="dc_editor-modal-content-container"><div class="dc_editor-modal-content"></div></div>')

    @overlay = jQuery('<div>', {class: 'dc_editor-modal-overlay'})

    @titleElement = @element.find('.dc_editor-modal-title')
    @contentContainerElement = @element.find('.dc_editor-modal-content-container')

    @contentElement = @element.find('.dc_editor-modal-content')

    @element.appendTo(jQuery(@options.appendTo).get(0) ? 'body')
    @overlay.appendTo(jQuery(@options.appendTo).get(0) ? 'body')


  bindEvents: ->
    DcEditor.on 'refresh', => @resize(true)
    DcEditor.on 'resize', => @position()

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
    height = DcEditor.displayRect.fullHeight - 20 if height > DcEditor.displayRect.fullHeight - 20 || @options.fullHeight

    @element.stop().animate {left: (DcEditor.displayRect.width - width) / 2, width: width, height: height}, 200, 'easeInOutSine', =>
      @contentElement.css({visibility: 'visible', display: 'block'})
      if @contentPane.length
        @contentElement.css({height: height - titleHeight, overflow: 'visible'})
        controlHeight = if @contentControl.length then @contentControl.outerHeight() else 0
        @contentPane.css({height: height - titleHeight - controlHeight - 40})
        @contentPane.find('.dc_editor-display-pane').css({width: width - 40})
      else
        @contentElement.css({height: height - titleHeight, overflow: 'auto'})


  position: ->
    viewportWidth = DcEditor.displayRect.width

    @contentPane.css({height: 'auto'}) if @contentPane
    @contentElement.css({height: 'auto'})
    @element.css({width: 'auto', height: 'auto', display: 'block', visibility: 'hidden'})

    width = @element.width()
    height = @element.height()

    width = @minWidth if width < @minWidth
    height = DcEditor.displayRect.fullHeight - 20 if height > DcEditor.displayRect.fullHeight - 20 || @options.fullHeight

    titleHeight = @titleElement.outerHeight()
    if @contentPane && @contentPane.length
      @contentElement.css({height: height - titleHeight, overflow: 'visible'})
      controlHeight = if @contentControl.length then @contentControl.outerHeight() else 0
      @contentPane.css({height: height - titleHeight - controlHeight - 40})
      @contentPane.find('.dc_editor-display-pane').css({width: width - 40})
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
          DcEditor.notify("DcEditor was unable to load %s for the modal.", @url)
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
