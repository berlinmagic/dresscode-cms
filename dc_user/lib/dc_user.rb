  require 'dresscode'
    
  require "devise"
  require "devise_invitable"

  # => require 'cancan'
  
  require 'dc/user/config'
  require 'dc/setters/user_setter'
  
  require 'dc_user_module'
  
  require 'helper/global_user'
  
  require 'dc_user/version'

module DcUser
  class Engine < Rails::Engine
    
    
    #config.autoload_paths += %W(#{config.root}/lib)
    
    
    
    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
    end
    
    #initializer 'user_helper.helper' do |app|
    #  ActionView::Base.send :include, UserHelper
    #end
    
    config.to_prepare &method(:activate).to_proc

  end
end