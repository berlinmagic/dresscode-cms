module DcContactform
  module Routes
    
    def dresscode_contactform_routes
      
      resources :contact_forms
      
    end
    
    def public_contactform_routes
      
      resources :contact_forms, :only => :create
      
    end
    
  end
end
module ActionDispatch::Routing
  class Mapper #:nodoc:
    include DcContactform::Routes
  end
end

