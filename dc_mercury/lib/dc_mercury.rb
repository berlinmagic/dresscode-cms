  require "rails/all"
  
  require 'dresscode'
  
  require 'paperclip' # => need to be replaced by dragonfly / data_file
  
  require 'dc_mercury/version'
  
  require 'dc_mercury/routes'
  
  require 'dc_mercury_hooks'
  require 'dc_mercury_module'


module DcMercury
  class Engine < Rails::Engine
    
    config.autoload_paths += %W(#{config.root}/lib)
    
    # Require dc_mercury authentication module and potentially other aspects later (so they can be overridden).
    initializer 'dc_mercury.add_lib' do |app|
      require 'dc_mercury/authentication'
    end
    
    def self.activate

      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env == "production" ? require(c) : load(c)
      end

    end
    config.to_prepare &method(:activate).to_proc
  end
end