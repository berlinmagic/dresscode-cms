# encoding: utf-8
module DcSidebar
  module Routes
    
    def dresscode_sidebar_routes
      resources :sidebars
    end
    
    def public_sidebar_routes
      # => your public routes
    end
    
  end
end
module ActionDispatch::Routing
  class Mapper #:nodoc:
    include DcSidebar::Routes
  end
end

