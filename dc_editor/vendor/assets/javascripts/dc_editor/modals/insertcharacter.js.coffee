@DcEditor.modalHandlers.insertCharacter = ->
  @element.find('.character').on 'click', (event) =>
    DcEditor.trigger('action', {action: 'insertHTML', value: "&#{jQuery(event.target).attr('data-entity')};"})
    @hide()
