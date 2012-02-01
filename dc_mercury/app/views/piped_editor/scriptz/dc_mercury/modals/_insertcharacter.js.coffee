@DcMercury.modalHandlers.insertCharacter = ->
  @element.find('.character').on 'click', (event) =>
    DcMercury.trigger('action', {action: 'insertHTML', value: "&#{jQuery(event.target).attr('data-entity')};"})
    @hide()
