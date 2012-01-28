# encoding: utf-8
module DcHeader
  module Routes
    
    def dresscode_header_routes
      # => your backend routes
    end
    
    def public_header_routes
      # => your public routes
    end
    
  end
end
module ActionDispatch::Routing
  class Mapper #:nodoc:
    include DcHeader::Routes
  end
end

