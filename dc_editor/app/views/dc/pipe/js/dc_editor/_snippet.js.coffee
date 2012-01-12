class @DcEditor.Snippet

  @all: []

  @displayOptionsFor: (name) ->
    DcEditor.modal DcEditor.config.snippets.optionsUrl.replace(':name', name), {
      title: 'Snippet Options'
      handler: 'insertSnippet'
      snippetName: name
    }
    DcEditor.snippet = null


  @create: (name, options) ->
    identity = "snippet_#{@all.length}"
    instance = new DcEditor.Snippet(name, identity, options)
    @all.push(instance)
    return instance


  @find: (identity) ->
    for snippet in @all
      return snippet if snippet.identity == identity
    return null


  @load: (snippets) ->
    for own identity, details of snippets
      instance = new DcEditor.Snippet(details.name, identity, details.options)
      @all.push(instance)


  constructor: (@name, @identity, options = {}) ->
    @version = 0
    @data = ''
    @history = new DcEditor.HistoryBuffer()
    @setOptions(options)


  getHTML: (context, callback = null) ->
    element = jQuery('<div class="dc_editor-snippet" contenteditable="false">', context)
    element.attr({'data-snippet': @identity})
    element.attr({'data-version': @version})
    element.html("[#{@identity}]")
    @loadPreview(element, callback)
    return element


  getText: (callback) ->
    return "[--#{@identity}--]"


  loadPreview: (element, callback = null) ->
    jQuery.ajax DcEditor.config.snippets.previewUrl.replace(':name', @name), {
      headers: DcEditor.ajaxHeaders()
      type: DcEditor.config.snippets.method
      data: @options
      success: (data) =>
        @data = data
        element.html(data)
        callback() if callback
      error: =>
        DcEditor.notify('Error loading the preview for the \"%s\" snippet.', @name)
    }


  displayOptions: ->
    DcEditor.snippet = @
    DcEditor.modal DcEditor.config.snippets.optionsUrl.replace(':name', @name), {
      title: 'Snippet Options',
      handler: 'insertSnippet',
      loadType: DcEditor.config.snippets.method,
      loadData: @options
    }


  setOptions: (@options) ->
    delete(@options['authenticity_token'])
    delete(@options['utf8'])
    @version += 1
    @history.push(@options)


  setVersion: (version = null) ->
    version = parseInt(version)
    if version && @history.stack[version - 1]
      @version = version - 1
      @options = @history.stack[@version]
      return true
    return false


  serialize: ->
    return {
      name: @name
      options: @options
    }
