module DcThemesStatic
  module Routes
    def dresscode_static_themes
      theme_dir = DcThemesStatic.config.themes_dir
      
      match "#{theme_dir}/:theme/stylesheets/*asset" => 'dc_themes_static/assets#stylesheets', 
                                        :format => false, :as => :base_theme_stylesheet
      match "#{theme_dir}/:theme/javascripts/*asset" => 'dc_themes_static/assets#javascripts', 
                                        :format => false, :as => :base_theme_javascript
      match "#{theme_dir}/:theme/images/*asset" => 'dc_themes_static/assets#images', 
                                        :format => false, :as => :base_theme_image
      
      # =>  NEW:    safes Production-Bild-Error
      # => match "/images/*asset" => 'dc_themes_static/assets#app_images', :as => :base_theme_image if Rails.env.production?
      match "/images/*asset" => 'dc_themes_static/assets#images', 
                                        :format => false, :as => :base_theme_image if Rails.env.production?
      match "/javascripts/*asset" => 'dc_themes_static/assets#javascripts', 
                                        :format => false, :as => :base_theme_javascript if Rails.env.production?
      match "/stylesheets/*asset" => 'dc_themes_static/assets#stylesheets', 
                                        :format => false, :as => :base_theme_stylesheet if Rails.env.production?
      
    end
  end
end
module ActionDispatch::Routing
  class Mapper #:nodoc:
    include DcThemesStatic::Routes
  end
end

