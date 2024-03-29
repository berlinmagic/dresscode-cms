class @DcMercury.PageEditor

  # options
  # saveStyle: 'form', or 'json' (defaults to json)
  # saveDataType: 'xml', 'json', 'jsonp', 'script', 'text', 'html' (defaults to json)
  # saveMethod: 'POST', or 'PUT', create or update actions on save (defaults to POST)
  # visible: boolean, if the interface should start visible or not (defaults to true)
  constructor: (@saveUrl = null, @options = {}) ->
    throw DcMercury.I18n('DcMercury.PageEditor can only be instantiated once.') if window.dc_mercuryInstance

    @options.visible = true unless (@options.visible == false || @options.visible == 'no')
    @visible = @options.visible

    window.dc_mercuryInstance = @
    @regions = []
    @initializeInterface()
    DcMercury.csrfToken = token if token = jQuery(DcMercury.config.csrfSelector).attr('content')


  initializeInterface: ->
    @focusableElement = jQuery('<input>', {class: 'dc_mercury-focusable', type: 'text'}).appendTo(@options.appendTo ? 'body')

    @iframe = jQuery('<iframe>', {id: 'dc_mercury_iframe', class: 'dc_mercury-iframe', seamless: 'true', frameborder: '0', src: 'about:blank'})
    @iframe.appendTo(jQuery(@options.appendTo).get(0) ? 'body')

    @toolbar = new DcMercury.Toolbar(@options)
    @statusbar = new DcMercury.Statusbar(@options)
    @resize()

    @iframe.on 'load', => @initializeFrame()
    @iframe.get(0).contentWindow.document.location.href = @iframeSrc(null, true)


  initializeFrame: ->
    try
      return if @iframe.data('loaded')
      @iframe.data('loaded', true)
      DcMercury.notify("Opera isn't a fully supported browser, your results may not be optimal.") if jQuery.browser.opera
      @document = jQuery(@iframe.get(0).contentWindow.document)
      stylesToInject = DcMercury.config.injectedStyles.replace(/{{regionClass}}/g, DcMercury.config.regions.className)
      jQuery("<style dc_mercury-styles=\"true\">").html(stylesToInject).appendTo(@document.find('head'))

      # jquery: make jQuery evaluate scripts within the context of the iframe window
      iframeWindow = @iframe.get(0).contentWindow
      jQuery.globalEval = (data) -> (iframeWindow.execScript || (data) -> iframeWindow["eval"].call(iframeWindow, data))(data) if (data && /\S/.test(data))

      iframeWindow.DcMercury = DcMercury
      iframeWindow.History = History if window.History && History.Adapter

      @bindEvents()
      @resize()
      @initializeRegions()
      @finalizeInterface()
      DcMercury.trigger('ready')
      jQuery(iframeWindow).trigger('dc_mercury:ready')
      iframeWindow.Event.fire(iframeWindow, 'dc_mercury:ready') if iframeWindow.Event && iframeWindow.Event.fire
      iframeWindow.onDcMercuryReady() if iframeWindow.onDcMercuryReady

      @iframe.css({visibility: 'visible'})
    catch error
      DcMercury.notify('DcMercury.PageEditor failed to load: %s\n\nPlease try refreshing.', error)


  initializeRegions: ->
    @regions = []
    @buildRegion(jQuery(region)) for region in jQuery(".#{DcMercury.config.regions.className}", @document)
    return unless @options.visible
    for region in @regions
      if region.focus
        region.focus()
        break


  buildRegion: (region) ->
    if region.data('region')
      region = region.data('region')
    else
      type = (region.data('type') || 'unknown').titleize()
      throw DcMercury.I18n('Region type is malformed, no data-type provided, or "%s" is unknown for the "%s" region.', type, region.attr('id') || 'unknown') if type == 'Unknown' || !DcMercury.Regions[type]
      if !DcMercury.Regions[type].supported
        DcMercury.notify('DcMercury.Regions.%s is unsupported in this client. Supported browsers are %s.', type, DcMercury.Regions[type].supportedText)
        return false
      region = new DcMercury.Regions[type](region, @iframe.get(0).contentWindow)
      region.togglePreview() if @previewing
    @regions.push(region)


  finalizeInterface: ->
    @santizerElement = jQuery('<div>', {id: 'dc_mercury_sanitizer', contenteditable: 'true', style: 'position:fixed;width:100px;height:100px;top:0;left:-100px;opacity:0;overflow:hidden'})
    @santizerElement.appendTo(@options.appendTo ? @document.find('body'))

    @snippetToolbar = new DcMercury.SnippetToolbar(@document)

    @hijackLinksAndForms()
    DcMercury.trigger('mode', {mode: 'preview'}) unless @options.visible


  bindEvents: ->
    DcMercury.on 'initialize:frame', => setTimeout(100, @initializeFrame)
    DcMercury.on 'focus:frame', => @iframe.focus()
    DcMercury.on 'focus:window', => setTimeout(10, => @focusableElement.focus())
    DcMercury.on 'toggle:interface', => @toggleInterface()
    DcMercury.on 'reinitialize', => @initializeRegions()
    DcMercury.on 'mode', (event, options) => @previewing = !@previewing if options.mode == 'preview'
    DcMercury.on 'action', (event, options) =>
      action = DcMercury.config.globalBehaviors[options.action] || @[options.action]
      return unless typeof(action) == 'function'
      options.already_handled = true
      action.call(@, options)

    @document.on 'mousedown', (event) ->
      DcMercury.trigger('hide:dialogs')
      if DcMercury.region
        DcMercury.trigger('unfocus:regions') unless jQuery(event.target).closest(".#{DcMercury.config.regions.className}").get(0) == DcMercury.region.element.get(0)

    jQuery(window).on 'resize', =>
      @resize()

    jQuery(@document).bind 'keydown', (event) =>
      return unless event.ctrlKey || event.metaKey
      if (event.keyCode == 83) # meta+S
        DcMercury.trigger('action', {action: 'save'})
        event.preventDefault()

    jQuery(window).bind 'keydown', (event) =>
      return unless event.ctrlKey || event.metaKey
      if (event.keyCode == 83) # meta+S
        DcMercury.trigger('action', {action: 'save'})
        event.preventDefault()

    window.onbeforeunload = @beforeUnload


  toggleInterface: ->
    if @visible
      DcMercury.trigger('mode', {mode: 'preview'}) if @previewing
      @visible = false
      @toolbar.hide()
      @statusbar.hide()
    else
      @visible = true
      @toolbar.show()
      @statusbar.show()
    DcMercury.trigger('mode', {mode: 'preview'})
    @resize()


  resize: ->
    width = jQuery(window).width()
    height = @statusbar.top()
    toolbarHeight = @toolbar.height()

    DcMercury.displayRect = {top: toolbarHeight, left: 0, width: width, height: height - toolbarHeight, fullHeight: height}

    @iframe.css {
      top: toolbarHeight
      left: 0
      height: height - toolbarHeight
    }

    DcMercury.trigger('resize')


  iframeSrc: (url = null, params = false) ->
    url = (url ? window.location.href).replace(DcMercury.editorUrlRegEx ?= /([http|https]:\/\/.[^\/]*)\/editor\/?(.*)/i,  "$1/$2")
    url = url.replace(/[\?|\&]dc_mercury_frame=true/gi, '')
    if params
      return "#{url}#{if url.indexOf('?') > -1 then '&' else '?'}dc_mercury_frame=true"
    else
      return url


  hijackLinksAndForms: ->
    for element in jQuery('a, form', @document)
      ignored = false
      for classname in DcMercury.config.nonHijackableClasses || []
        if jQuery(element).hasClass(classname)
          ignored = true
          continue
      if !ignored && (element.target == '' || element.target == '_self') && !jQuery(element).closest(".#{DcMercury.config.regions.className}").length
        jQuery(element).attr('target', '_parent')


  beforeUnload: ->
    if DcMercury.changes && !DcMercury.silent
      return DcMercury.I18n('You have unsaved changes.  Are you sure you want to leave without saving them first?')
    return null


  getRegionByName: (id) ->
    for region in @regions
      return region if region.name == id
    return null


  save: (callback) ->
    url = @saveUrl ? DcMercury.saveURL ? @iframeSrc()
    data = @serialize()
    DcMercury.log('saving', data)
    data = jQuery.toJSON(data) unless @options.saveStyle == 'form'
    method = 'PUT' if @options.saveMethod == 'PUT'
    jQuery.ajax url, {
      headers: DcMercury.ajaxHeaders()
      type: method || 'POST'
      dataType: @options.saveDataType || 'json'
      data: {content: data, _method: method}
      success: =>
        DcMercury.changes = false
        DcMercury.trigger('saved')
        callback() if typeof(callback) == 'function'
      error: =>
        DcMercury.notify('DcMercury was unable to save to the url: %s', url)
    }


  serialize: ->
    serialized = {}
    serialized[region.name] = region.serialize() for region in @regions
    return serialized
