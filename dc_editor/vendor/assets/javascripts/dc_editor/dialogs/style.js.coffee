@DcEditor.dialogHandlers.style = ->
  @element.find('[data-class]').on 'click', (event) =>
    className = jQuery(event.target).data('class')
    DcEditor.trigger('action', {action: 'style', value: className})
