Rails.application.routes.draw do
  
  namespace :dc do
    
    resources :twidgets
    
    resources :tlayouts do
      resources :telements
      member do
        post :mercury_update
      end
      collection do
        post :reorder_zeilen
      end
    end
    
    resources :telements do
      resources :telements
      resources :styles
      resources :tcontents
      # => resources :class_assignments
      # => resources :style_classes
      dc_style_classes
    end
    
    resources :tcontents
    
    resources :rasters
    
    resources :tag_assignments
    
    resources :tag_lists
    
    
    match '/get_raster/style_:id.:format' => "rasters#get_raster"
    
    resources :styles
    
    resources :class_assignments
    
    resources :style_classes
    
  end
  
end
