class @DcEditor.PageEditor

  # options
  # saveStyle: 'form', or 'json' (defaults to json)
  # saveDataType: 'xml', 'json', 'jsonp', 'script', 'text', 'html' (defaults to json)
  # saveMethod: 'POST', or 'PUT', create or update actions on save (defaults to POST)
  # visible: boolean, if the interface should start visible or not (defaults to true)
  constructor: (@saveUrl = null, @options = {}) ->
    throw DcEditor.I18n('DcEditor.PageEditor is unsupported in this client. Supported browsers are chrome 10+, firefix 4+, and safari 5+.') unless DcEditor.supported
    throw DcEditor.I18n('DcEditor.PageEditor can only be instantiated once.') if window.dc_editorInstance

    @options.visible = true unless @options.visible == false
    @visible = @options.visible

    window.dc_editorInstance = @
    @regions = []
    @initializeInterface()
    DcEditor.csrfToken = token if token = jQuery(DcEditor.config.csrfSelector).attr('content')


  initializeInterface: ->
    @focusableElement = jQuery('<input>', {class: 'dc_editor-focusable', type: 'text'}).appendTo(@options.appendTo ? 'body')

    @iframe = jQuery('<iframe>', {id: 'dc_editor_iframe', class: 'dc_editor-iframe', seamless: 'true', frameborder: '0', src: 'about:blank'})
    @iframe.appendTo(jQuery(@options.appendTo).get(0) ? 'body')

    @toolbar = new DcEditor.Toolbar(@options)
    @statusbar = new DcEditor.Statusbar(@options)
    @resize()

    @iframe.on 'load', => @initializeFrame()
    @iframe.get(0).contentWindow.document.location.href = @iframeSrc()


  initializeFrame: ->
    try
      return if @iframe.data('loaded')
      @iframe.data('loaded', true)
      DcEditor.notify("Opera isn't a fully supported browser, your results may not be optimal.") if jQuery.browser.opera
      @document = jQuery(@iframe.get(0).contentWindow.document)
      stylesToInject = DcEditor.config.injectedStyles.replace(/{{regionClass}}/g, DcEditor.config.regionClass)
      jQuery("<style dc_editor-styles=\"true\">").html(stylesToInject).appendTo(@document.find('head'))

      # jquery: make jQuery evaluate scripts within the context of the iframe window
      # todo: look into `context` options for ajax as an alternative -- didn't seem to work in the initial tests
      iframeWindow = @iframe.get(0).contentWindow
      jQuery.globalEval = (data) -> (iframeWindow.execScript || (data) -> iframeWindow["eval"].call(iframeWindow, data))(data) if (data && /\S/.test(data))

      iframeWindow.DcEditor = DcEditor
      iframeWindow.History = History if window.History && History.Adapter

      @bindEvents()
      @resize()
      @initializeRegions()
      @finalizeInterface()
      DcEditor.trigger('ready')
      jQuery(iframeWindow).trigger('dc_editor:ready')
      iframeWindow.Event.fire(iframeWindow, 'dc_editor:ready') if iframeWindow.Event && iframeWindow.Event.fire
      iframeWindow.onDcEditorReady() if iframeWindow.onDcEditorReady

      @iframe.css({visibility: 'visible'})
    catch error
      DcEditor.notify('DcEditor.PageEditor failed to load: %s\n\nPlease try refreshing.', error)


  initializeRegions: ->
    @regions = []
    @buildRegion(jQuery(region)) for region in jQuery(".#{DcEditor.config.regionClass}", @document)
    return unless @options.visible
    for region in @regions
      if region.focus
        region.focus()
        break


  buildRegion: (region) ->
    try
      if region.data('region')
        region = region.data('region')
      else
        type = region.data('type').titleize()
        region = new DcEditor.Regions[type](region, @iframe.get(0).contentWindow)
        region.togglePreview() if @previewing
      @regions.push(region)
    catch error
      DcEditor.notify(error) if DcEditor.debug
      DcEditor.notify('Region type is malformed, no data-type provided, or "%s" is unknown for the "%s" region.', type, region.attr('id') || 'unknown')


  finalizeInterface: ->
    @santizerElement = jQuery('<div>', {id: 'dc_editor_sanitizer', contenteditable: 'true', style: 'position:fixed;width:100px;height:100px;top:0;left:-100px;opacity:0;overflow:hidden'})
    @santizerElement.appendTo(@options.appendTo ? @document.find('body'))

    @snippetToolbar = new DcEditor.SnippetToolbar(@document)

    @hijackLinksAndForms()
    DcEditor.trigger('mode', {mode: 'preview'}) unless @options.visible


  bindEvents: ->
    DcEditor.on 'initialize:frame', => setTimeout(100, @initializeFrame)
    DcEditor.on 'focus:frame', => @iframe.focus()
    DcEditor.on 'focus:window', => setTimeout(10, => @focusableElement.focus())
    DcEditor.on 'toggle:interface', => @toggleInterface()
    DcEditor.on 'reinitialize', => @initializeRegions()
    DcEditor.on 'mode', (event, options) => @previewing = !@previewing if options.mode == 'preview'
    DcEditor.on 'action', (event, options) => @save() if options.action == 'save'

    @document.on 'mousedown', (event) ->
      DcEditor.trigger('hide:dialogs')
      if DcEditor.region
        DcEditor.trigger('unfocus:regions') unless jQuery(event.target).closest(".#{DcEditor.config.regionClass}").get(0) == DcEditor.region.element.get(0)

    jQuery(window).on 'resize', =>
      @resize()

    window.onbeforeunload = @beforeUnload


  toggleInterface: ->
    if @visible
      DcEditor.trigger('mode', {mode: 'preview'}) if @previewing
      @visible = false
      @toolbar.hide()
      @statusbar.hide()
    else
      @visible = true
      @toolbar.show()
      @statusbar.show()
    DcEditor.trigger('mode', {mode: 'preview'})
    @resize()


  resize: ->
    width = jQuery(window).width()
    height = @statusbar.top()
    toolbarHeight = @toolbar.height()

    DcEditor.displayRect = {top: toolbarHeight, left: 0, width: width, height: height - toolbarHeight, fullHeight: height}

    @iframe.css {
      top: toolbarHeight
      left: 0
      height: height - toolbarHeight
    }

    DcEditor.trigger('resize')


  iframeSrc: (url = null) ->
    (url ? window.location.href).replace(/([http|https]:\/\/.[^\/]*)\/editor\/?(.*)/i, "$1/$2")


  hijackLinksAndForms: ->
    for element in jQuery('a, form', @document)
      ignored = false
      for classname in DcEditor.config.nonHijackableClasses || []
        if jQuery(element).hasClass(classname)
          ignored = true
          continue
      if !ignored && (element.target == '' || element.target == '_self') && !jQuery(element).closest(".#{DcEditor.config.regionClass}").length
        jQuery(element).attr('target', '_top')


  beforeUnload: ->
    if DcEditor.changes && !DcEditor.silent
      return DcEditor.I18n('You have unsaved changes.  Are you sure you want to leave without saving them first?')
    return null


  getRegionByName: (id) ->
    for region in @regions
      return region if region.name == id
    return null


  save: (callback) ->
    url = @saveUrl ? DcEditor.saveURL ? @iframeSrc()
    data = @serialize()
    DcEditor.log('saving', data)
    data = jQuery.toJSON(data) unless @options.saveStyle == 'form'
    method = 'PUT' if @options.saveMethod == 'PUT'
    jQuery.ajax url, {
      headers: DcEditor.ajaxHeaders()
      type: method || 'POST'
      dataType: @options.saveDataType || 'json'
      data: {content: data, _method: method}
      success: =>
        callback() if callback
        DcEditor.changes = false
        DcEditor.trigger('saved')
      error: =>
        DcEditor.notify('DcEditor was unable to save to the url: %s', url)
    }


  serialize: ->
    serialized = {}
    serialized[region.name] = region.serialize() for region in @regions
    return serialized
