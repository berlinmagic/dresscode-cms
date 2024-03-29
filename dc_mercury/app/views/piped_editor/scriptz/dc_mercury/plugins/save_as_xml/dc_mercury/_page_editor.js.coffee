class DcMercury.PageEditor extends DcMercury.PageEditor

  save: ->
    url = @saveUrl ? DcMercury.saveURL ? @iframeSrc()
    data = @serializeAsXml()
    console.log('saving', data)
    return
    method = 'PUT' if @options.saveMethod == 'PUT'
    jQuery.ajax url, {
      headers: DcMercury.ajaxHeaders()
      type: method || 'POST'
      dataType: 'xml'
      data: data
      success: =>
        DcMercury.changes = false
      error: =>
        alert("DcMercury was unable to save to the url: #{url}")
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