# ## Require all the dependencies
#= require dc_editor/dependencies/jquery-ui-1.8.13.custom
#= require dc_editor/dependencies/jquery.additions
#= require dc_editor/dependencies/jquery.htmlClean
#= require dc_editor/dependencies/liquidmetal
#= require dc_editor/dependencies/showdown
#
# ## Require all dc_editor files
#= require_self
#= require ./native_extensions
#= require ./page_editor
#= require ./history_buffer
#= require ./table_editor
#= require ./dialog
#= require ./palette
#= require ./select
#= require ./panel
#= require ./modal
#= require ./lightview
#= require ./statusbar
#= require ./toolbar
#= require ./toolbar.button
#= require ./toolbar.button_group
#= require ./toolbar.expander
#= require ./tooltip
#= require ./snippet
#= require ./snippet_toolbar
#= require ./region
#= require ./uploader
#= require_tree ./regions
#= require_tree ./dialogs
#= require_tree ./modals
#= require ./finalize
#
@DcEditor ||= {}
jQuery.extend @DcEditor,
  version: '0.2.3'

  # No IE support yet because it doesn't follow the W3C standards for HTML5 contentEditable (aka designMode).
  # todo: move these into the specific region types -- some would be supported, just not the primary ones?
  supported: document.getElementById && document.designMode && !jQuery.browser.konqueror && !jQuery.browser.msie

  # DcEditor object namespaces
  Regions: DcEditor.Regions || {}
  modalHandlers: DcEditor.modalHandlers || {}
  lightviewHandlers: DcEditor.lightviewHandlers || {}
  dialogHandlers: DcEditor.dialogHandlers || {}
  preloadedViews: DcEditor.preloadedViews || {}

  # Custom ajax headers
  ajaxHeaders: ->
    headers = {}
    headers[DcEditor.config.csrfHeader] = DcEditor.csrfToken
    return headers


  # Custom event methods
  on: (eventName, callback) ->
    jQuery(top).on("dc_editor:#{eventName}", callback)


  trigger: (eventName, options) ->
    DcEditor.log(eventName, options)
    jQuery(top).trigger("dc_editor:#{eventName}", options)


  bind: (eventName, callback) -> # todo: deprecated -- use 'on' instead
    DcEditor.deprecated('DcEditor.bind is deprecated, use DcEditor.on instead')
    DcEditor.on(eventName, callback)


  # Alerting and logging methods
  notify: (args...) ->
    window.alert(DcEditor.I18n.apply(@, args))


  warn: (message, severity = 0) ->
    if console
      try console.warn(message)
      catch e1
        if severity >= 1
          try console.debug(message) catch e2
    else if severity >= 1
      DcEditor.notify(message)


  deprecated: (message)->
    message = "#{message} -- #{console.trace()}" if console && console.trace
    #throw "deprecated: #{message}"
    DcEditor.warn("deprecated: #{message}", 1)


  log: ->
    if DcEditor.debug && console
      return if arguments[0] == 'hide:toolbar' || arguments[0] == 'show:toolbar'
      try console.debug(arguments)
      catch e


  # I18n / Translation methods
  locale: ->
    return DcEditor.determinedLocale if DcEditor.determinedLocale
    if DcEditor.config.localization.enabled
      locale = []
      if navigator.language && (locale = navigator.language.toString().split('-')).length
        topLocale = DcEditor.I18n[locale[0]] || {}
        subLocale = if locale.length > 1 then topLocale["_#{locale[1].toUpperCase()}_"]
      if !DcEditor.I18n[locale[0]]
        locale = DcEditor.config.localization.preferredLocale.split('-')
        topLocale = DcEditor.I18n[locale[0]] || {}
        subLocale = if locale.length > 1 then topLocale["_#{locale[1].toUpperCase()}_"]
    return DcEditor.determinedLocale = {top: topLocale || {}, sub: subLocale || {}}


  I18n: (sourceString, args...) ->
    locale = DcEditor.locale()
    translation = (locale.sub[sourceString] || locale.top[sourceString] || sourceString || '').toString()
    return if args.length then translation.printf.apply(translation, args) else translation
