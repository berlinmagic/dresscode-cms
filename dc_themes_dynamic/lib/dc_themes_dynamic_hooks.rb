# encoding: utf-8
class DcThemesDynamicHooks < HookSupport::HookListener

  insert_after :dc_system_footer_after_pages do
    "<%= render 'dynamic/xchange/system_footer' %>"
  end
  
  
  
end
