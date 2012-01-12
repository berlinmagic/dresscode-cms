@DcEditor.modalHandlers.insertSnippet = ->
  @element.find('form').on 'submit', (event) =>
    event.preventDefault()
    serializedForm = @element.find('form').serializeObject()
    if DcEditor.snippet
      snippet = DcEditor.snippet
      snippet.setOptions(serializedForm)
      DcEditor.snippet = null
    else
      snippet = DcEditor.Snippet.create(@options.snippetName, serializedForm)
    DcEditor.trigger('action', {action: 'insertSnippet', value: snippet})
    @hide()
