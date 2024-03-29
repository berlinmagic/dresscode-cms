  require "rails/all"
  
  require 'dresscode'
  
  require 'dc_carte/version'
  
  require 'dc_carte/routes'
  require 'dc_carte/dc_carte_pass'
  
  require 'dc_carte_hooks'
  require 'dc_carte_module'
  
  require 'carte/config'


module DcCarte
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