@DcMercury.modalHandlers.htmlEditor = ->
  # fill the text area with the content
  content = DcMercury.region.content(null, true, false)
  @element.find('textarea').val(content)

  # replace the contents on form submit
  @element.find('form').on 'submit', (event) =>
    event.preventDefault()
    value = @element.find('textarea').val().replace(/\n/g, '')
    DcMercury.trigger('action', {action: 'replaceHTML', value: value})
    @hide()
