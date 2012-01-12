@DcEditor.dialogHandlers.formatblock = ->
  @element.find('[data-tag]').on 'click', (event) =>
    tag = jQuery(event.target).data('tag')
    DcEditor.trigger('action', {action: 'formatblock', value: tag})
