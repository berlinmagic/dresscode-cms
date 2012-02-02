@DcMercury.modalHandlers.insertMedien = ->
	
	
  # make the inputs work with the radio buttons, and options
  @element.find('.select_pic').on 'click', (event) =>
    element = jQuery(event.target)
    # @element.find("#media_image_url").val( element.find(".pic_url").html() )
    @element.find(".media-options").hide()
    @element.find("##{element.attr('id')}_urls").show()
    @resize(true)
    

  @element.find('.selectable').on 'focus', (event) =>
    element = jQuery(event.target)
    element.prev('label').find('input[type=radio]').prop("checked", true)

    @element.find(".media-options").hide()
    @element.find("##{element.attr('id').replace('media_', '')}").show()
    @resize(true)


  # get the selection and initialize its information into the form
  if DcMercury.region && DcMercury.region.selection
    selection = DcMercury.region.selection()

    if selection && selection.commonAncestor
      @element.find("#media_with_opt").html( selection.commonAncestor().width() )

    # if we're editing an image prefill the information
    if selection.is && image = selection.is('img')
      @element.find('#media_image_url').val(image.attr('src'))
      @element.find('#media_image_alignment').val(image.attr('align'))
      setTimeout 300, => @element.find('#media_image_url').focus()



  # build the image or youtube embed on form submission
  @element.find('form').on 'submit', (event) =>
    event.preventDefault()
    type = @element.find('input[name=media_type]:checked').val()

    attrs = {src: @element.find('#media_image_url').val()}
    attrs['align'] = alignment if alignment = @element.find('#media_image_alignment').val()
    DcMercury.trigger('action', {action: 'insertImage', value: attrs})

    @hide()
