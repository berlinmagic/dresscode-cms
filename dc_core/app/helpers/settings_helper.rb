# encoding: utf-8
module SettingsHelper
  
  def dc_pref_bool_tag( object, pref='' )
    if !pref.blank?
      stuff =  hidden_field_tag("preferences[#{ object }]", "DC::#{pref}".constantize::Config["#{ object }"])
      stuff +=  link_to('', '#', :class => "on_off_schalter #{"DC::#{pref}".constantize::Config["#{ object }"] ? 'an' : 'aus'}")
    else
      stuff =  hidden_field_tag("preferences[#{ object }]", DC::Config["#{ object }"])
      stuff +=  link_to('', '#', :class => "on_off_schalter #{DC::Config["#{ object }"] ? 'an' : 'aus'}")
    end
    raw( stuff )
  end
  
  def dc_pref_text_field( object, pref='' )
    if !pref.blank?
      stuff = text_field_tag( "preferences[#{ object }]", "DC::#{pref}".constantize::Config[ "#{ object }" ] )
    else
      stuff = text_field_tag( "preferences[#{ object }]", DC::Config[ "#{ object }" ] )
    end
    raw( stuff )
  end
  
  def dc_pref_select_tag( object, option, pref='' )
    if !pref.blank?
      stuff = select_tag( "preferences[#{ object }]", options_for_select( option, "DC::#{pref}".constantize::Config["#{ object }"]) )
    else
      stuff = select_tag( "preferences[#{ object }]", options_for_select( option, DC::Config["#{ object }"]) )
    end
    raw( stuff )
  end
  
  def dc_pref_text_line( object, pref='' )
    da_line = dc_pref_text_field( object, pref )
    dc_pref_line( object, da_line )
  end
  
  def dc_pref_bool_line( object, pref='' )
    da_line = dc_pref_bool_tag( object, pref )
    dc_pref_line( object, da_line )
  end
  
  def dc_pref_select_line( object, option, pref='' )
    da_line = dc_pref_select_tag( object, option, pref='' )
    dc_pref_line( object, da_line )
  end
  
  def dc_pref_line( name, objekt )
    name_line = content_tag( 'div', I18n.t("dc.config.#{ name }"), :class => 'dc_pref_name fl_box_230' )
    pref_line = content_tag( 'div', objekt, :class => 'dc_pref fl_box_310' )
    clear_line = content_tag( 'div', '', :class => 'clearfix' )
    content_tag( 'div', name_line + pref_line + clear_line, :class => 'dc_preference_line' )
  end

end