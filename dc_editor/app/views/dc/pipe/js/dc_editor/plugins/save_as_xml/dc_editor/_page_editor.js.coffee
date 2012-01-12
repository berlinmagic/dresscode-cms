class DcEditor.PageEditor extends DcEditor.PageEditor

  save: ->
    url = @saveUrl ? DcEditor.saveURL ? @iframeSrc()
    data = @serializeAsXml()
    console.log('saving', data)
    return
    method = 'PUT' if @options.saveMethod == 'PUT'
    jQuery.ajax url, {
      headers: DcEditor.ajaxHeaders()
      type: method || 'POST'
      dataType: 'xml'
      data: data
      success: =>
        DcEditor.changes = false
      error: =>
        alert("DcEditor was unable to save to the url: #{url}")
    }

  serializeAsXml: ->
    data = @serialize()
    regionNodes = []
    for regionName, regionProperties of data
      snippetNodes = []
      for snippetName, snippetProperties of regionProperties['snippets']
        snippetNodes.push("<#{snippetName} name=\"#{snippetProperties['name']}\"><![CDATA[#{jQuery.toJSON(snippetProperties['options'])}]]></#{snippetName}>")
      regionNodes.push("<region name=\"#{regionName}\" type=\"#{regionProperties['type']}\"><value>\n<![CDATA[#{regionProperties['value']}]]>\n</value><snippets>#{snippetNodes.join('')}</snippets></region>")
    return "<regions>#{regionNodes.join('')}</regions>"