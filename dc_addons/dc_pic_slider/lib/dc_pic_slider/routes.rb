# encoding: utf-8
module DcPicSlider
  module Routes
    
    def dresscode_pic_slider_routes
      # => your backend routes
    end
    
    def public_pic_slider_routes
      # => your public routes
    end
    
  end
end
module ActionDispatch::Routing
  class Mapper #:nodoc:
    include DcPicSlider::Routes
  end
end

