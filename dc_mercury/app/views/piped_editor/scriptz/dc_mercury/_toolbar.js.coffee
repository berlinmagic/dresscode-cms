class @DcMercury.Toolbar

  constructor: (@options = {}) ->
    @visible = @options.visible
    @build()
    @bindEvents()


  build: ->
    @element = jQuery('<div>', {class: 'dc_mercury-toolbar-container', style: 'width:10000px'})
    @element.css({display: 'none'}) unless @visible
    @element.appendTo(jQuery(@options.appendTo).get(0) ? 'body')

    for own toolbarName, buttons of DcMercury.config.toolbars
      continue if buttons._custom
      toolbar = jQuery('<div>', {class: "dc_mercury-toolbar dc_mercury-#{toolbarName}-toolbar"}).appendTo(@element)
      toolbar.attr('data-regions', buttons._regions) if buttons._regions
      container = jQuery('<div>', {class: 'dc_mercury-toolbar-button-container'}).appendTo(toolbar)

      for own buttonName, options of buttons
        continue if buttonName == '_regions'
        button = @buildButton(buttonName, options)
        button.appendTo(container) if button

      if container.css('white-space') == 'nowrap'
        expander = new DcMercury.Toolbar.Expander(toolbarName, {appendTo: toolbar, for: container})
        expander.appendTo(@element)

      toolbar.addClass('disabled') if DcMercury.config.toolbars['primary'] && toolbarName != 'primary'

    @element.css({width: '100%'})


  buildButton: (name, options) ->
    return false if name[0] == '_'
    switch jQuery.type(options)
      when 'array' # button
        [title, summary, handled] = options
        new DcMercury.Toolbar.Button(name, title, summary, handled, {appendDialogsTo: @element})

      when 'object' # button group
        group = new DcMercury.Toolbar.ButtonGroup(name, options)
        for own action, opts of options
          button = @buildButton(action, opts)
          button.appendTo(group) if button
        group

      when 'string' # separator
        jQuery('<hr>', {class: "dc_mercury-#{if options == '-' then 'line-separator' else 'separator'}"})

      else throw DcMercury.I18n('Unknown button structure -- please provide an array, object, or string for "%s".', name)


  bindEvents: ->
    DcMercury.on 'region:focused', (event, options) =>
      for toolbar in @element.find(".dc_mercury-toolbar")
        toolbar = jQuery(toolbar)
        if regions = toolbar.data('regions')
          toolbar.removeClass('disabled') if regions.split(',').indexOf(options.region.type) > -1

    DcMercury.on 'region:blurred', (event, options) =>
      for toolbar in @element.find(".dc_mercury-toolbar")
        toolbar = jQuery(toolbar)
        if regions = toolbar.data('regions')
          toolbar.addClass('disabled') if regions.split(',').indexOf(options.region.type) > -1

    @element.on 'click', ->
      DcMercury.trigger('hide:dialogs')

    @element.on 'mousedown', (event) ->
      event.preventDefault()


  height: ->
    if @visible then @element.outerHeight() else 0


  show: ->
    @visible = true
    @element.css({top: -@element.outerHeight(), display: 'block'})
    @element.animate({top: 0}, 200, 'easeInOutSine')


  hide: ->
    @visible = false
    @element.hide()
