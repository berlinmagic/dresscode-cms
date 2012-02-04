# encoding: utf-8
class DcSidebarHooks < HookSupport::HookListener
  
  # => insert_after :dc_sidebar_module_settings do
  # =>   '= link_to(
  # =>   					dc_icon( :icon => 54, :color => "dunkel" ) + " Sidebar", 
  # =>   					view_dcr_settings_path( "contact", "form" ), 
  # =>   					:class => "#{ "aktiv" if @name && @name == "form" }"
  # =>   				) '
  # => end
  
  insert_after :dc_system_footer_after_pages do
    "<%= render 'dc/sidebars/footer' %>"
  end
  
  replace :public_page_view do
    "<%= render 'static/layouts/page_view', :page => page %>"
  end
  
  insert_after :public_stylesheets do
    "<%= render 'pipe/module_stylez/public/sidebars' %>"
  end
  
  insert_after :public_javascriptz do
    "<%= render 'pipe/module_scriptz/public/sidebars' %>"
  end
  
end
