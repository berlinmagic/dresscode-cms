@DcEditor.dialogHandlers.backColor = ->
  @element.find('.picker, .last-picked').on 'click', (event) =>
    color = jQuery(event.target).css('background-color')
    @element.find('.last-picked').css({background: color})
    @button.css({backgroundColor: color})
    DcEditor.trigger('action', {action: 'backColor', value: color})
