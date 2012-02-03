# encoding: utf-8
class DcCarteHooks < HookSupport::HookListener
  
  insert_after :dc_system_footer_after_pages do
    "<%= render 'dc/cartes/footer' %>"
  end
  
end
