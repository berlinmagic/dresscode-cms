  require "rails/all"
  
  require 'dresscode'
  
  require 'dc_tags/version'
  
  require 'dc_tags/routes'
  
  require 'dc_tags_hooks'
  require 'dc_tags_module'
  
  require 'tags/config'


module DcTags
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