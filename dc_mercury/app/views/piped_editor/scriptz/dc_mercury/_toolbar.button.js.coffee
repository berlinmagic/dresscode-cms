class @DcMercury.Toolbar.Button

  constructor: (@name, @title, @summary = null, @types = {}, @options = {}) ->
    @title = DcMercury.I18n(@title) if @title
    @summary = DcMercury.I18n(@summary) if @summary

    @build()
    @bindEvents()
    return @element


  build: ->
    @element = jQuery('<div>', {title: @summary ? @title, class: "dc_mercury-button dc_mercury-#{@name}-button"}).html("<em>#{@title}</em>")
    @element.data('expander', "<div class=\"dc_mercury-expander-button\" data-button=\"#{@name}\"><em></em><span>#{@title}</span></div>")

    @handled = {}

    for own type, mixed of @types
      switch type
        when 'preload' then true

        when 'regions'
          @element.addClass('disabled')
          @handled[type] = if jQuery.isFunction(mixed) then mixed.call(@, @name) else mixed

        when 'toggle'
          @handled[type] = true

        when 'mode'
          @handled[type] = if mixed == true then @name else mixed

        when 'context'
          @handled[type] = if jQuery.isFunction(mixed) then mixed else DcMercury.Toolbar.Button.contexts[@name]

        when 'palette'
          @element.addClass("dc_mercury-button-palette")
          url = if jQuery.isFunction(mixed) then mixed.call(@, @name) else mixed
          @handled[type] = new DcMercury.Palette(url, @name, @defaultDialogOptions())

        when 'select'
          @element.addClass("dc_mercury-button-select").find('em').html(@title)
          url = if jQuery.isFunction(mixed) then mixed.call(@, @name) else mixed
          @handled[type] = new DcMercury.Select(url, @name, @defaultDialogOptions())

        when 'panel'
          @element.addClass('dc_mercury-button-panel')
          url = if jQuery.isFunction(mixed) then mixed.call(@, @name) else mixed
          @handled['toggle'] = true
          @handled[type] = new DcMercury.Panel(url, @name, @defaultDialogOptions())

        when 'modal'
          @handled[type] = if jQuery.isFunction(mixed) then mixed.apply(@, @name) else mixed

        when 'lightview'
          @handled[type] = if jQuery.isFunction(mixed) then mixed.apply(@, @name) else mixed

        else throw DcMercury.I18n('Unknown button type \"%s\" used for the \"%s\" button.', type, @name)


  bindEvents: ->
    DcMercury.on 'button', (event, options) => @element.click() if options.action == @name
    DcMercury.on 'mode', (event, options) => @togglePressed() if @handled.mode == options.mode && @handled.toggle

    DcMercury.on 'region:update', (event, options) =>
      if @handled.context && options.region && jQuery.type(options.region.currentElement) == 'function'
        element = options.region.currentElement()
        if element.length && @handled.context.call(@, element, options.region.element)
          @element.addClass('active')
        else
          @element.removeClass('active')
      else
        @element.removeClass('active')

    DcMercury.on 'region:focused', (event, options) =>
      if @handled.regions && options.region && options.region.type
        if @handled.regions.indexOf(options.region.type) > -1
          @element.removeClass('disabled')
        else
          @element.addClass('disabled')

    DcMercury.on 'region:blurred', =>
      @element.addClass('disabled') if @handled.regions

    @element.on 'mousedown', =>
      @element.addClass('active')

    @element.on 'mouseup', =>
      @element.removeClass('active')

    @element.on 'click', (event) =>
      if @element.closest('.disabled').length then return

      handled = false
      for own type, mixed of @handled
        switch type
          when 'toggle'
            @togglePressed() unless @handled.mode

          when 'mode'
            handled = true
            DcMercury.trigger('mode', {mode: mixed})

          when 'modal'
            handled = true
            DcMercury.modal(@handled.modal, {title: @summary || @title, handler: @name})

          when 'lightview'
            handled = true
            DcMercury.lightview(@handled.lightview, {title: @summary || @title, handler: @name, closeButton: true})

          when 'palette', 'select', 'panel'
            event.stopPropagation()
            handled = true
            @handled[type].toggle()

      DcMercury.trigger('action', {action: @name}) unless handled
      DcMercury.trigger('focus:frame') if @options['regions'] && @options['regions'].length


  defaultDialogOptions: ->
    return {
      title: @summary || @title
      preload: @types.preload
      appendTo: @options.appendDialogsTo || 'body'
      closeButton: true
      for: @element
    }


  togglePressed: ->
    @element.toggleClass('pressed')



# Button contexts
@DcMercury.Toolbar.Button.contexts =

  backColor: (node) -> @element.css('background-color', node.css('background-color'))

  foreColor: (node) -> @element.css('background-color', node.css('color'))

  bold: (node) ->
    weight = node.css('font-weight')
    weight == 'bold' || weight > 400

  italic: (node) -> node.css('font-style') == 'italic'

  # overline is weird because <u> and <strike> override text-decoration -- we can't always tell without checking parents
  overline: (node) ->
    return true if node.css('text-decoration') == 'overline'
    for parent in node.parentsUntil(@element)
      return true if jQuery(parent).css('text-decoration') == 'overline'
    return false

  strikethrough: (node, region) -> node.css('text-decoration') == 'line-through' || !!node.closest('strike', region).length

  underline: (node, region) -> node.css('text-decoration') == 'underline' || !!node.closest('u', region).length

  subscript: (node, region) -> !!node.closest('sub', region).length

  superscript: (node, region) -> !!node.closest('sup', region).length

  justifyLeft: (node) -> node.css('text-align').indexOf('left') > -1

  justifyCenter: (node) -> node.css('text-align').indexOf('center') > -1

  justifyRight: (node) -> node.css('text-align').indexOf('right') > -1

  justifyFull: (node) -> node.css('text-align').indexOf('justify') > -1

  insertOrderedList: (node, region) -> !!node.closest('ol', region.element).length

  insertUnorderedList: (node, region) -> !!node.closest('ul', region.element).length
