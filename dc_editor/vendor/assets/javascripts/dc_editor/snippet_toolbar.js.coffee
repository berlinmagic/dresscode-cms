class @DcEditor.SnippetToolbar extends DcEditor.Toolbar

  constructor: (@document, @options = {}) ->
    super(@options)


  build: ->
    @element = jQuery('<div>', {class: 'dc_editor-toolbar dc_editor-snippet-toolbar', style: 'display:none'})
    @element.appendTo(jQuery(@options.appendTo).get(0) ? 'body')

    for own buttonName, options of DcEditor.config.toolbars.snippetable
      button = @buildButton(buttonName, options)
      button.appendTo(@element) if button


  bindEvents: ->
    DcEditor.on 'show:toolbar', (event, options) =>
      return unless options.snippet
      options.snippet.mouseout => @hide()
      @show(options.snippet)

    DcEditor.on 'hide:toolbar', (event, options) =>
      return unless options.type && options.type == 'snippet'
      @hide(options.immediately)

    @element.mousemove =>
      clearTimeout(@hideTimeout)

    @element.mouseout =>
      @hide()

    jQuery(@document).on 'scroll', =>
      @position() if @visible


  show: (@snippet) ->
    DcEditor.tooltip.hide()
    @position()
    @appear()


  position: ->
    offset = @snippet.offset()

    top = offset.top + DcEditor.displayRect.top - jQuery(@document).scrollTop() - @height() + 10
    left = offset.left - jQuery(@document).scrollLeft()

    @element.css {
      top: top
      left: left
    }


  appear: ->
    clearTimeout(@hideTimeout)
    return if @visible
    @visible = true
    @element.css({display: 'block', opacity: 0})
    @element.stop().animate({opacity: 1}, 200, 'easeInOutSine')


  hide: (immediately = false) ->
    clearTimeout(@hideTimeout)
    if immediately
      @element.hide()
      @visible = false
    else
      @hideTimeout = setTimeout 500, =>
        @element.stop().animate {opacity: 0}, 300, 'easeInOutSine', =>
          @element.hide()
        @visible = false

