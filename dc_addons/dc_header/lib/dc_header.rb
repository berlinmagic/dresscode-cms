  require "rails/all"
  
  require 'dresscode'
  
  require 'dc_header/version'
  
  require 'dc_header/routes'
  
  require 'dc_header_hooks'
  require 'dc_header_module'
  
  require 'header/config'


module DcHeader
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