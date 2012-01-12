class @DcEditor.Region
  type = 'region'

  constructor: (@element, @window, @options = {}) ->
    @type = 'region' unless @type
    DcEditor.log("building #{@type}", @element, @options)

    @document = @window.document
    @name = @element.attr('id')
    @collectDataAttributes()
    @history = new DcEditor.HistoryBuffer()
    @build()
    @bindEvents()
    @pushHistory()
    @element.data('region', @)


  build: ->


  focus: ->


  collectDataAttributes: ->
    @data = {}
    $(DcEditor.config.regionDataAttributes).each (index, item) =>
      @data[item] = @element.attr('data-' + item)

  bindEvents: ->
    DcEditor.on 'mode', (event, options) => @togglePreview() if options.mode == 'preview'

    DcEditor.on 'focus:frame', =>
      return if @previewing || DcEditor.region != @
      @focus()

    DcEditor.on 'action', (event, options) =>
      return if @previewing || DcEditor.region != @
      @execCommand(options.action, options) if options.action

    @element.on 'mousemove', (event) =>
      return if @previewing || DcEditor.region != @
      snippet = jQuery(event.target).closest('.dc_editor-snippet')
      if snippet.length
        @snippet = snippet
        DcEditor.trigger('show:toolbar', {type: 'snippet', snippet: @snippet})

    @element.on 'mouseout', =>
      return if @previewing
      DcEditor.trigger('hide:toolbar', {type: 'snippet', immediately: false})


  content: (value = null, filterSnippets = false) ->
    if value != null
      @element.html(value)
    else
      # sanitize the html before we return it
      container = jQuery('<div>').appendTo(@document.createDocumentFragment())
      container.html(@element.html().replace(/^\s+|\s+$/g, ''))

      # replace snippet contents to be an identifier
      if filterSnippets then for snippet in container.find('.dc_editor-snippet')
        snippet = jQuery(snippet)
        snippet.attr({contenteditable: null, 'data-version': null})
        snippet.html("[#{snippet.data('snippet')}]")

      return container.html()


  togglePreview: ->
    if @previewing
      @previewing = false
      @element.addClass(DcEditor.config.regionClass).removeClass("#{DcEditor.config.regionClass}-preview")
      @focus() if DcEditor.region == @
    else
      @previewing = true
      @element.addClass("#{DcEditor.config.regionClass}-preview").removeClass(DcEditor.config.regionClass)
      DcEditor.trigger('region:blurred', {region: @})


  execCommand: (action, options = {}) ->
    @focus()
    @pushHistory() unless action == 'redo'

    DcEditor.log('execCommand', action, options.value)
    DcEditor.changes = true


  pushHistory: ->
    @history.push(@content())


  snippets: ->
    snippets = {}
    for element in @element.find('[data-snippet]')
      snippet = DcEditor.Snippet.find(jQuery(element).data('snippet'))
      snippet.setVersion(jQuery(element).data('version'))
      snippets[snippet.identity] = snippet.serialize()
    return snippets


  serialize: ->
    return {
      type: @type
      data: @data
      value: @content(null, true)
      snippets: @snippets()
    }
