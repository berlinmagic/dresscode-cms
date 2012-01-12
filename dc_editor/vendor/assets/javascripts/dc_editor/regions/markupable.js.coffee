# todo:
# context for the toolbar buttons and groups needs to change so we can do the following:
# how to handle context for buttons?  if the cursor is within a bold area (**bo|ld**), or selecting it -- it would be
# nice if we could activate the bold button for instance.

class @DcEditor.Regions.Markupable extends DcEditor.Region
  type = 'markupable'

  constructor: (@element, @window, @options = {}) ->
    @type = 'markupable'
    super
    @converter = new Showdown.converter()


  build: ->
    width = '100%'
    height = @element.height()

    value = @element.html().replace(/^\s+|\s+$/g, '').replace('&gt;', '>')
    @element.removeClass(DcEditor.config.regionClass)
    @textarea = jQuery('<textarea>', @document).val(value)
    @textarea.attr('class', @element.attr('class')).addClass('dc_editor-textarea')
    @textarea.css({border: 0, background: 'transparent', display: 'block', 'overflow-y': 'hidden', width: width, height: height, fontFamily: '"Courier New", Courier, monospace'})
    @element.addClass(DcEditor.config.regionClass)
    @element.empty().append(@textarea)

    @previewElement = jQuery('<div>', @document)
    @element.append(@previewElement)
    @container = @element
    @container.data('region', @)
    @element = @textarea
    @resize()


  bindEvents: ->
    DcEditor.on 'mode', (event, options) => @togglePreview() if options.mode == 'preview'
    DcEditor.on 'focus:frame', => @focus() if !@previewing && DcEditor.region == @

    DcEditor.on 'action', (event, options) =>
      return if @previewing || DcEditor.region != @
      @execCommand(options.action, options) if options.action

    DcEditor.on 'unfocus:regions', =>
      return if @previewing || DcEditor.region != @
      @element.blur()
      @container.removeClass('focus')
      DcEditor.trigger('region:blurred', {region: @})

    @element.on 'dragenter', (event) =>
      return if @previewing
      event.preventDefault()
      event.originalEvent.dataTransfer.dropEffect = 'copy'

    @element.on 'dragover', (event) =>
      return if @previewing
      event.preventDefault()
      event.originalEvent.dataTransfer.dropEffect = 'copy'

    @element.on 'drop', (event) =>
      return if @previewing

      # handle dropping snippets
      if DcEditor.snippet
        event.preventDefault()
        @focus()
        DcEditor.Snippet.displayOptionsFor(DcEditor.snippet)

      # handle any files that were dropped
      if event.originalEvent.dataTransfer.files.length
        event.preventDefault()
        @focus()
        DcEditor.uploader(event.originalEvent.dataTransfer.files[0])

    @element.on 'focus', =>
      return if @previewing
      DcEditor.region = @
      @container.addClass('focus')
      DcEditor.trigger('region:focused', {region: @})

    @element.on 'keydown', (event) =>
      return if @previewing
      @resize()
      switch event.keyCode
        when 90 # undo / redo
          return unless event.metaKey
          event.preventDefault()
          if event.shiftKey then @execCommand('redo') else @execCommand('undo')
          return

        when 13 # enter or return
          selection = @selection()
          text = @element.val()
          start = text.lastIndexOf('\n', selection.start)
          end = text.indexOf('\n', selection.end)
          end = text.length if end < start
          start = text.lastIndexOf('\n', selection.start - 1) if text[start] == '\n'
          if text[start + 1] == '-'
            selection.replace('\n- ', false, true)
            event.preventDefault()
          if /\d/.test(text[start + 1])
            lineText = text.substring(start, end)
            if /(\d+)\./.test(lineText)
              number = parseInt(RegExp.$1)
              selection.replace("\n#{number += 1}. ", false, true)
              event.preventDefault()

        when 9 # tab
          event.preventDefault()
          @execCommand('insertHTML', {value: '  '})

      if event.metaKey
        switch event.keyCode
          when 66 # b
            @execCommand('bold')
            event.preventDefault()

          when 73 # i
            @execCommand('italic')
            event.preventDefault()

          when 85 # u
            @execCommand('underline')
            event.preventDefault()

      @pushHistory(event.keyCode)

    @element.on 'keyup', =>
      return if @previewing
      DcEditor.changes = true
      @resize()
      DcEditor.trigger('region:update', {region: @})

    @element.on 'mouseup', =>
      return if @previewing
      @focus()
      DcEditor.trigger('region:focused', {region: @})

    @previewElement.on 'click', (event) =>
      $(event.target).closest('a').attr('target', '_top') if @previewing


  focus: ->
    @element.focus()


  content: (value = null, filterSnippets = true) ->
    if value != null
      if jQuery.type(value) == 'string'
        @element.val(value)
      else
        @element.val(value.html)
        @selection().select(value.selection.start, value.selection.end)
    else
      return @element.val()


  contentAndSelection: ->
    return {html: @content(null, false), selection: @selection().serialize()}


  togglePreview: ->
    if @previewing
      @previewing = false
      @container.addClass(DcEditor.config.regionClass).removeClass("#{DcEditor.config.regionClass}-preview")
      @previewElement.hide()
      @element.show()
      @focus() if DcEditor.region == @
    else
      @previewing = true
      @container.addClass("#{DcEditor.config.regionClass}-preview").removeClass(DcEditor.config.regionClass)
      value = @converter.makeHtml(@element.val())
      @previewElement.html(value)
      @previewElement.show()
      @element.hide()
      DcEditor.trigger('region:blurred', {region: @})


  execCommand: (action, options = {}) ->
    super

    handler.call(@, @selection(), options) if handler = DcEditor.Regions.Markupable.actions[action]
    @resize()


  pushHistory: (keyCode) ->
    # when pressing return, delete or backspace it should push to the history
    # all other times it should store if there's a 1 second pause
    keyCodes = [13, 46, 8]
    waitTime = 2.5
    knownKeyCode = keyCodes.indexOf(keyCode) if keyCode

    # clear any pushes to the history
    clearTimeout(@historyTimeout)

    # if the key code was return, delete, or backspace store now -- unless it was the same as last time
    if knownKeyCode >= 0 && knownKeyCode != @lastKnownKeyCode # || !keyCode
      @history.push(@contentAndSelection())
    else if keyCode
      # set a timeout for pushing to the history
      @historyTimeout = setTimeout(waitTime * 1000, => @history.push(@contentAndSelection()))
    else
      # push to the history immediately
      @history.push(@contentAndSelection())

    @lastKnownKeyCode = knownKeyCode


  selection: ->
    return new DcEditor.Regions.Markupable.Selection(@element)


  resize: ->
    @element.css({height: @element.get(0).scrollHeight - 100})
    @element.css({height: @element.get(0).scrollHeight});


  snippets: ->


  # Actions
  @actions: {

    undo: -> @content(@history.undo())

    redo: -> @content(@history.redo())

    insertHTML: (selection, options) ->
      if options.value.get && element = options.value.get(0)
        options.value = jQuery('<div>').html(element).html()
      selection.replace(options.value, false, true)

    insertImage: (selection, options) ->
      selection.replace('![add alt text](' + encodeURI(options.value.src) + ')', true)

    insertTable: (selection, options) ->
      selection.replace(options.value.replace(/<br>|<br\/>/ig, ''), false, true)

    insertLink: (selection, options) ->
      selection.replace("[#{options.value.content}](#{options.value.attrs.href} 'optional title')", true)

    insertUnorderedList: (selection) -> selection.addList('unordered')

    insertOrderedList: (selection) -> selection.addList('ordered')

    style: (selection, options) -> selection.wrap("<span class=\"#{options.value}\">", '</span>')

    formatblock: (selection, options) ->
      wrappers = {
        h1: ['# ', ' #']
        h2: ['## ', ' ##']
        h3: ['### ', ' ###']
        h4: ['#### ', ' ####']
        h5: ['##### ', ' #####']
        h6: ['###### ', ' ######']
        pre: ['    ', '']
        blockquote: ['> ', '']
        p: ['\n', '\n']
      }
      selection.unWrapLine("#{wrapper[0]}", "#{wrapper[1]}") for wrapperName, wrapper of wrappers
      if options.value == 'blockquote'
        DcEditor.Regions.Markupable.actions.indent.call(@, selection, options)
        return
      selection.wrapLine("#{wrappers[options.value][0]}", "#{wrappers[options.value][1]}")

    bold: (selection) -> selection.wrap('**', '**')

    italic: (selection) -> selection.wrap('_', '_')

    subscript: (selection) -> selection.wrap('<sub>', '</sub>')

    superscript: (selection) -> selection.wrap('<sup>', '</sup>')

    indent: (selection) ->
      selection.wrapLine('> ', '', false, true)

    outdent: (selection) ->
      selection.unWrapLine('> ', '', false, true)

    horizontalRule: (selection) -> selection.replace('\n- - -\n')

    insertSnippet: (selection, options) ->
      snippet = options.value
      selection.replace(snippet.getText())

  }


# Helper class for managing selection and getting information from it
class DcEditor.Regions.Markupable.Selection

  constructor: (@element) ->
    @el = @element.get(0)
    @getDetails()


  serialize: ->
    return {start: @start, end: @end}


  getDetails: ->
    @length = @el.selectionEnd - @el.selectionStart
    @start = @el.selectionStart
    @end = @el.selectionEnd
    @text = @element.val().substr(@start, @length)


  replace: (text, select = false, placeCursor = false) ->
    @getDetails()
    val = @element.val()
    savedVal = @element.val()
    @element.val(val.substr(0, @start) + text + val.substr(@end, val.length))
    changed = @element.val() != savedVal
    @select(@start, @start + text.length) if select
    @select(@start + text.length, @start + text.length) if placeCursor
    return changed


  select: (@start, @end) ->
    @element.focus()
    @el.selectionStart = @start
    @el.selectionEnd = @end
    @getDetails()


  wrap: (left, right) ->
    @getDetails()
    @deselectNewLines()
    @replace(left + @text + right, @text != '')
    @select(@start + left.length, @start + left.length) if @text == ''


  wrapLine: (left, right, selectAfter = true, reselect = false) ->
    @getDetails()
    savedSelection = @serialize()
    text = @element.val()
    start = text.lastIndexOf('\n', @start)
    end = text.indexOf('\n', @end)
    end = text.length if end < start
    start = text.lastIndexOf('\n', @start - 1) if text[start] == '\n'
    @select(start + 1, end)
    @replace(left + @text + right, selectAfter)
    @select(savedSelection.start + left.length, savedSelection.end + left.length) if reselect


  unWrapLine: (left, right, selectAfter = true, reselect = false) ->
    @getDetails()
    savedSelection = @serialize()
    text = @element.val()
    start = text.lastIndexOf('\n', @start)
    end = text.indexOf('\n', @end)
    end = text.length if end < start
    start = text.lastIndexOf('\n', @start - 1) if text[start] == '\n'
    @select(start + 1, end)
    window.something = @text
    leftRegExp = new RegExp("^#{left.regExpEscape()}")
    rightRegExp = new RegExp("#{right.regExpEscape()}$")
    changed = @replace(@text.replace(leftRegExp, '').replace(rightRegExp, ''), selectAfter)
    @select(savedSelection.start - left.length, savedSelection.end - left.length) if reselect && changed


  addList: (type) ->
    text = @element.val()
    start = text.lastIndexOf('\n', @start)
    end = text.indexOf('\n', @end)
    end = text.length if end < start
    start = text.lastIndexOf('\n', @start - 1) if text[start] == '\n'
    @select(start + 1, end)
    lines = @text.split('\n')
    if type == 'unordered'
      @replace("- " + lines.join("\n- "), true)
    else
      @replace(("#{index + 1}. #{line}" for line, index in lines).join('\n'), true)


  deselectNewLines: ->
    text = @text
    length = text.replace(/\n+$/g, '').length
    @select(@start, @start + length)


  placeMarker: ->
    @wrap('[dc_editor-marker]', '[dc_editor-marker]')


  removeMarker: ->
    val = @element.val()
    start = val.indexOf('[dc_editor-marker]')
    return unless start > -1
    end = val.indexOf('[dc_editor-marker]', start + 1) - '[dc_editor-marker]'.length
    @element.val(@element.val().replace(/\[dc_editor-marker\]/g, ''))
    @select(start, end)


  textContent: ->
    return @text
