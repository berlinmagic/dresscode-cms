module DcCore
  module Routes
    
    def dresscode_core_routes
      
      namespace :admin do
        root :to => 'base#dashboard'
      end
      
      resources :settings, :only => :index do
        collection do
          get '/:config/:name' => :show_config, :as => 'view'
          post '/:config/:name/change' => :update_config, :as => 'change'
        end
      end
      
      resources :data_files do
        member do
          get :original
        end
        collection do
          get :pix_only
          get :data_only
        end
      end
      
      # => root :to => 'base#dashboard'
      root :to => 'pages#index'
      
    end
    
    def dresscode_pipe_routes
      
      namespace :pipe do
        # = J A V A S C R I P T S
        match '/script/library/:script.:format'           => "scriptz#library"
        match '/script/plugin/:script.:format'            => "scriptz#plugin"
        
        match '/script/public/:theme.:format'             => "scriptz#public"
        match '/script/dc_libs.:format'                   => "scriptz#dc_js"
        
        match '/script/dtheme.:format'                    => "scriptz#dtheme"
        
        # = S T Y L E S H E E T S
        match '/styles/library/:style.:format'            => "stylez#library"
        match '/styles/plugin/:style.:format'             => "stylez#plugin"
        
        match '/styles/public/:theme.:format'             => 'stylez#public'
        match '/styles/dc/libs.:format'                   => 'stylez#dc_style'
        
        match '/styles/dynamic/template/tl_:id.:format'   => 'stylez#dynamic_template'
        match '/styles/dynamic/:style.:format'            => 'stylez#dynamic_dc_style'
      end
      
    end
  end
end
module ActionDispatch::Routing
  class Mapper #:nodoc:
    include DcCore::Routes
  end
end

