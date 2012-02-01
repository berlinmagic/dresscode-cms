class @DcMercury.Region
  type = 'region'

  constructor: (@element, @window, @options = {}) ->
    @type = 'region' unless @type
    DcMercury.log("building #{@type}", @element, @options)

    @document = @window.document
    @name = @element.attr(DcMercury.config.regions.identifier)
    @history = new DcMercury.HistoryBuffer()
    @build()
    @bindEvents()
    @pushHistory()
    @element.data('region', @)


  build: ->


  focus: ->


  bindEvents: ->
    DcMercury.on 'mode', (event, options) => @togglePreview() if options.mode == 'preview'

    DcMercury.on 'focus:frame', =>
      return if @previewing || DcMercury.region != @
      @focus()

    DcMercury.on 'action', (event, options) =>
      return if @previewing || DcMercury.region != @
      @execCommand(options.action, options) if options.action

    @element.on 'mousemove', (event) =>
      return if @previewing || DcMercury.region != @
      snippet = jQuery(event.target).closest('.dc_mercury-snippet')
      if snippet.length
        @snippet = snippet
        DcMercury.trigger('show:toolbar', {type: 'snippet', snippet: @snippet})

    @element.on 'mouseout', =>
      return if @previewing
      DcMercury.trigger('hide:toolbar', {type: 'snippet', immediately: false})


  content: (value = null, filterSnippets = false) ->
    if value != null
      @element.html(value)
    else
      # sanitize the html before we return it
      container = jQuery('<div>').appendTo(@document.createDocumentFragment())
      container.html(@element.html().replace(/^\s+|\s+$/g, ''))

      # replace snippet contents to be an identifier
      if filterSnippets then for snippet in container.find('.dc_mercury-snippet')
        snippet = jQuery(snippet)
        snippet.attr({contenteditable: null, 'data-version': null})
        snippet.html("[#{snippet.data('snippet')}]")

      return container.html()


  togglePreview: ->
    if @previewing
      @previewing = false
      @element.addClass(DcMercury.config.regions.className).removeClass("#{DcMercury.config.regions.className}-preview")
      @focus() if DcMercury.region == @
    else
      @previewing = true
      @element.addClass("#{DcMercury.config.regions.className}-preview").removeClass(DcMercury.config.regions.className)
      DcMercury.trigger('region:blurred', {region: @})


  execCommand: (action, options = {}) ->
    @focus()
    @pushHistory() unless action == 'redo'

    DcMercury.log('execCommand', action, options.value)
    DcMercury.changes = true unless options.already_handled


  pushHistory: ->
    @history.push(@content())


  snippets: ->
    snippets = {}
    for element in @element.find('[data-snippet]')
      snippet = DcMercury.Snippet.find(jQuery(element).data('snippet'))
      snippet.setVersion(jQuery(element).data('version'))
      snippets[snippet.identity] = snippet.serialize()
    return snippets


  dataAttributes: ->
    data = {}
    data[attr] = @element.attr('data-' + attr) for attr in DcMercury.config.regions.dataAttributes
    return data


  serialize: ->
    return {
      type: @type
      data: @dataAttributes()
      value: @content(null, true)
      snippets: @snippets()
    }
