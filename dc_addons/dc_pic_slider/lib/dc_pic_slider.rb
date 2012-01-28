  require "rails/all"
  
  require 'dresscode'
  
  require 'dc_pic_slider/version'
  
  require 'dc_pic_slider/routes'
  
  require 'dc_pic_slider_hooks'
  require 'dc_pic_slider_module'
  
  require 'pic_slider/config'


module DcPicSlider
  class Engine < Rails::Engine
    config.autoload_paths += %W(#{config.root}/lib)
    def self.activate

      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env == "production" ? require(c) : load(c)
      end

    end
    config.to_prepare &method(:activate).to_proc
  end
end