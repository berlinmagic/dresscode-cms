# encoding: utf-8
  
  require "rails/all"
  
  require "dc_core"
  require "dc_editor"
  require "dc_lists"
  require "dc_pages"
  
  # => require "dc_staticthemes"
  require "dc_themes_static"
  require "dc_themes_dynamic"
  
  require "dc_user"
  
  require "dc/version"
  
  
module DC
  
  class Engine < Rails::Engine
    
  end
  
end
