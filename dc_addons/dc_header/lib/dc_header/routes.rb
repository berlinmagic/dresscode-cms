# encoding: utf-8
module DcHeader
  module Routes
    
    def dresscode_header_routes
      
      resources :headers do
        member do
          get :new_pic
          post :new_pic_up
          get '/crop_pic/:pic' => :crop_pic, :as => 'crop_pic'
          post '/crop_up/:pic' => :crop_up, :as => 'crop_up'
          delete '/remove/:pic' => :remove_pic, :as => 'remove_pic'
          # => post :blowup
          # => put :cropit
          # => get :select
          # => delete :remove
        end
      end
      
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

