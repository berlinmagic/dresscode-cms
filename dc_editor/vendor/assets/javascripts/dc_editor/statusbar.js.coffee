class @DcEditor.Statusbar

  constructor: (@options = {}) ->
    @visible = @options.visible
    @build()
    @bindEvents()


  build: ->
    @element = jQuery('<div>', {class: 'dc_editor-statusbar'})
    @aboutElement = jQuery('<a>', {class: "dc_editor-statusbar-about"}).appendTo(@element).html("DcEditor Editor v#{DcEditor.version}")
    @pathElement = jQuery('<div>', {class: 'dc_editor-statusbar-path'}).appendTo(@element)

    @element.css({visibility: 'hidden'}) unless @visible
    @element.appendTo(jQuery(@options.appendTo).get(0) ? 'body')


  bindEvents: ->
    DcEditor.on 'region:update', (event, options) =>
      @setPath(options.region.path()) if options.region && jQuery.type(options.region.path) == 'function'

    @aboutElement.on 'click', =>
      DcEditor.lightview('/dc_editor/lightviews/about.html', {title: "DcEditor Editor v#{DcEditor.version}"})


  height: ->
    @element.outerHeight()


  top: ->
    top =  @element.offset().top
    currentTop = if parseInt(@element.css('bottom')) < 0 then top - @element.outerHeight() else top
    if @visible then currentTop else top + @element.outerHeight()


  setPath: (elements) ->
    path = []
    path.push("<a>#{element.tagName.toLowerCase()}</a>") for element in elements

    @pathElement.html("<span><strong>#{DcEditor.I18n('Path:')} </strong>#{path.reverse().join(' &raquo; ')}</span>")


  show: ->
    @visible = true
    @element.css({opacity: 0, visibility: 'visible'})
    @element.animate({opacity: 1}, 200, 'easeInOutSine')


  hide: ->
    @visible = false
    @element.css({visibility: 'hidden'})