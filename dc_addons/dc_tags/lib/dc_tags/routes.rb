# encoding: utf-8
module DcTags
  module Routes
    
    def dresscode_tags_routes
      # => your backend routes
    end
    
    def public_tags_routes
      # => your public routes
    end
    
  end
end
module ActionDispatch::Routing
  class Mapper #:nodoc:
    include DcTags::Routes
  end
end

