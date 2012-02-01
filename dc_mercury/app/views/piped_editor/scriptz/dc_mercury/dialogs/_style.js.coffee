@DcMercury.dialogHandlers.style = ->
  @element.find('[data-class]').on 'click', (event) =>
    className = jQuery(event.target).data('class')
    DcMercury.trigger('action', {action: 'style', value: className})
