# encoding: utf-8
class DcHeaderHooks < HookSupport::HookListener
  
  # => insert_after :dc_sidebar_module_settings do
  # =>   '= link_to(
  # =>   					dc_icon( :icon => 54, :color => "dunkel" ) + " Header", 
  # =>   					view_dcr_settings_path( "contact", "form" ), 
  # =>   					:class => "#{ "aktiv" if @name && @name == "form" }"
  # =>   				) '
  # => end
  
  insert_after :dc_system_footer_after_pages do
    "<%= render 'dc/headers/footer' %>"
  end
  
  replace :dc_main_banner do
    "<%= render_cell :header, :display, :page => @page %>"
  end
  
  insert_after :js_stuff do
    "<%= render_cell :header, :script, :page => @page %>"
  end
  
end
