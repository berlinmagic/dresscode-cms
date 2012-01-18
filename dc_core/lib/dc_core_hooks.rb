# encoding: utf-8
class DcCoreHooks < HookSupport::HookListener
  
  insert_after :admin_main_right_navigation do
    "<%= link_to 'Einstellungen', dc_settings_url, :class => ('aktiv' if @aktivio == 'settings') %>"
  end
  
  # => insert_after :site_headline do
  # =>   "<h1>Hallo vom Hook !</h1><br/>"
  # => end
  # => insert_after :site_headline do
  # =>   "<h1>Hallo vom Hook !</h1><br/>"
  # => end
  # => insert_after :site_headline do
  # =>   "<h1>Hallo vom Hook !</h1><br/>"
  # => end
  
end
