module DcThemesDynamic
  module StyleClassRoutes
    
    def dc_style_classes
      resources :style_classes do
        member do
          post    :select_style_class
          get     :select_style_class
          delete  :remove_style_class
        end
        collection do
          post    :available_style_classes
          get     :available_style_classes
          # => post    :new_data_tag
        end
      end
    end
    
  end
end
module ActionDispatch::Routing
  class Mapper #:nodoc:
    include DcThemesDynamic::StyleClassRoutes
  end
end

