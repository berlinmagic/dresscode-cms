@DcMercury ||= {}
jQuery.extend @DcMercury,
  version: '0.8.15'

  # DcMercury object namespaces
  Regions: DcMercury.Regions || {}
  modalHandlers: DcMercury.modalHandlers || {}
  lightviewHandlers: DcMercury.lightviewHandlers || {}
  dialogHandlers: DcMercury.dialogHandlers || {}
  preloadedViews: DcMercury.preloadedViews || {}

  # Custom ajax headers
  ajaxHeaders: ->
    headers = {}
    headers[DcMercury.config.csrfHeader] = DcMercury.csrfToken
    return headers


  # Custom event methods
  on: (eventName, callback) ->
    jQuery(window).on("dc_mercury:#{eventName}", callback)


  trigger: (eventName, options) ->
    DcMercury.log(eventName, options)
    jQuery(window).trigger("dc_mercury:#{eventName}", options)


  # Alerting and logging methods
  notify: (args...) ->
    window.alert(DcMercury.I18n.apply(@, args))


  warn: (message, severity = 0) ->
    if console
      try console.warn(message)
      catch e1
        if severity >= 1
          try console.debug(message) catch e2
    else if severity >= 1
      DcMercury.notify(message)


  deprecated: (message)->
    message = "#{message} -- #{console.trace()}" if console && console.trace
    #throw "deprecated: #{message}"
    DcMercury.warn("deprecated: #{message}", 1)


  log: ->
    if DcMercury.debug && console
      return if arguments[0] == 'hide:toolbar' || arguments[0] == 'show:toolbar'
      try console.debug(arguments)
      catch e


  # I18n / Translation methods
  locale: ->
    return DcMercury.determinedLocale if DcMercury.determinedLocale
    if DcMercury.config.localization.enabled
      locale = []
      if navigator.language && (locale = navigator.language.toString().split('-')).length
        topLocale = DcMercury.I18n[locale[0]] || {}
        subLocale = if locale.length > 1 then topLocale["_#{locale[1].toUpperCase()}_"]
      if !DcMercury.I18n[locale[0]]
        locale = DcMercury.config.localization.preferredLocale.split('-')
        topLocale = DcMercury.I18n[locale[0]] || {}
        subLocale = if locale.length > 1 then topLocale["_#{locale[1].toUpperCase()}_"]
    return DcMercury.determinedLocale = {top: topLocale || {}, sub: subLocale || {}}


  I18n: (sourceString, args...) ->
    locale = DcMercury.locale()
    translation = (locale.sub[sourceString] || locale.top[sourceString] || sourceString || '').toString()
    return if args.length then translation.printf.apply(translation, args) else translation
