@DcMercury.dialogHandlers.foreColor = ->
  @element.find('.picker, .last-picked').on 'click', (event) =>
    color = jQuery(event.target).css('background-color')
    @element.find('.last-picked').css({background: color})
    @button.css({backgroundColor: color})
    DcMercury.trigger('action', {action: 'foreColor', value: color})
