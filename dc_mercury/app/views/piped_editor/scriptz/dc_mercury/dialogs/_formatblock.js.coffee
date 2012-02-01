@DcMercury.dialogHandlers.formatblock = ->
  @element.find('[data-tag]').on 'click', (event) =>
    tag = jQuery(event.target).data('tag')
    DcMercury.trigger('action', {action: 'formatblock', value: tag})
