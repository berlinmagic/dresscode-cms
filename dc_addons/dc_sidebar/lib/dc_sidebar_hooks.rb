# encoding: utf-8
class DcSidebarHooks < HookSupport::HookListener
  
  # => insert_after :dc_sidebar_module_settings do
  # =>   '= link_to(
  # =>   					dc_icon( :icon => 54, :color => "dunkel" ) + " Sidebar", 
  # =>   					view_dcr_settings_path( "contact", "form" ), 
  # =>   					:class => "#{ "aktiv" if @name && @name == "form" }"
  # =>   				) '
  # => end
  
  # => insert_after :dc_system_footer_after_pages do
  # =>   "= render 'dc/your/partial/path' "
  # => end
  
end
