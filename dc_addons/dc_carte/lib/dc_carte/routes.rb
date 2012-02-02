# encoding: utf-8
module DcCarte
  module Routes
    
    def dresscode_carte_routes
      # => your backend routes
    end
    
    def public_carte_routes
      # => your public routes
    end
    
  end
end
module ActionDispatch::Routing
  class Mapper #:nodoc:
    include DcCarte::Routes
  end
end

