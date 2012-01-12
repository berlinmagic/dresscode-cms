@DcEditor.modalHandlers.insertTable = ->
  table = @element.find('#table_display table')

  # make td's selectable
  table.on 'click', (event) =>
    cell = jQuery(event.target)
    table = cell.closest('table')
    table.find('.selected').removeAttr('class')
    cell.addClass('selected')
    DcEditor.tableEditor(table, cell, '&nbsp;')

  # select the first td
  firstCell = table.find('td, th').first()
  firstCell.addClass('selected')
  DcEditor.tableEditor(table, firstCell, '&nbsp;')

  # make the buttons work
  @element.find('input.action').on 'click', (event) =>
    action = jQuery(event.target).attr('name')
    switch action
      when 'insertRowBefore' then DcEditor.tableEditor.addRow('before')
      when 'insertRowAfter' then DcEditor.tableEditor.addRow('after')
      when 'deleteRow' then DcEditor.tableEditor.removeRow()
      when 'insertColumnBefore' then DcEditor.tableEditor.addColumn('before')
      when 'insertColumnAfter' then DcEditor.tableEditor.addColumn('after')
      when 'deleteColumn' then DcEditor.tableEditor.removeColumn()
      when 'increaseColspan' then DcEditor.tableEditor.increaseColspan()
      when 'decreaseColspan' then DcEditor.tableEditor.decreaseColspan()
      when 'increaseRowspan' then DcEditor.tableEditor.increaseRowspan()
      when 'decreaseRowspan' then DcEditor.tableEditor.decreaseRowspan()

  # set the alignment
  @element.find('#table_alignment').on 'change', =>
    table.attr({align: @element.find('#table_alignment').val()})

  # set the border
  @element.find('#table_border').on 'keyup', =>
    table.attr({border: parseInt(@element.find('#table_border').val())})

  # set the cellspacing
  @element.find('#table_spacing').on 'keyup', =>
    table.attr({cellspacing: parseInt(@element.find('#table_spacing').val())})

  # build the table on form submission
  @element.find('form').on 'submit', (event) =>
    event.preventDefault()
    table.find('.selected').removeAttr('class')
    table.find('td, th').html('<br/>')

    html = jQuery('<div>').html(table).html()
    value = html.replace(/^\s+|\n/gm, '').replace(/(<\/.*?>|<table.*?>|<tbody>|<tr>)/g, '$1\n')

    DcEditor.trigger('action', {action: 'insertTable', value: value})
    @hide()
