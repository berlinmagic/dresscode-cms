class @DcEditor.Toolbar.ButtonGroup

  constructor: (@name, @options = {}) ->
    @build()
    @bindEvents()
    @regions = @options._regions
    return @element


  build: ->
    @element = jQuery('<div>', {class: "dc_editor-button-group dc_editor-#{@name}-group"})
    if @options._context || @options._regions
      @element.addClass('disabled')


  bindEvents: ->
    DcEditor.on 'region:update', (event, options) =>
      context = DcEditor.Toolbar.ButtonGroup.contexts[@name]
      if context
        if options.region && jQuery.type(options.region.currentElement) == 'function'
          element = options.region.currentElement()
          if element.length && context.call(@, element, options.region.element)
            @element.removeClass('disabled')
          else
            @element.addClass('disabled')

    DcEditor.on 'region:focused', (event, options) =>
      if @regions && options.region && options.region.type
        if @regions.indexOf(options.region.type) > -1
          @element.removeClass('disabled') unless @options._context
        else
          @element.addClass('disabled')

    DcEditor.on 'region:blurred', (event, options) =>
      @element.addClass('disabled') if @options.regions



# ButtonGroup contexts
@DcEditor.Toolbar.ButtonGroup.contexts =

  table: (node, region) -> !!node.closest('table', region).length
