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
      stuff = text_field_tag( "preferences[#{ object }]", "DC::#{pref}".constantize::Config[ "#{ object }" ], :size => 50 )
    else
      stuff = text_field_tag( "preferences[#{ object }]", DC::Config[ "#{ object }" ], :size => 50 )
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

end