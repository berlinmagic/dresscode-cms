@DcMercury.modalHandlers.insertSnippet = ->
  @element.find('form').on 'submit', (event) =>
    event.preventDefault()
    serializedForm = @element.find('form').serializeObject()
    if DcMercury.snippet
      snippet = DcMercury.snippet
      snippet.setOptions(serializedForm)
      DcMercury.snippet = null
    else
      snippet = DcMercury.Snippet.create(@options.snippetName, serializedForm)
    DcMercury.trigger('action', {action: 'insertSnippet', value: snippet})
    @hide()
