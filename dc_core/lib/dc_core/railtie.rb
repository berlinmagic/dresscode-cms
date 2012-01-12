module DcCore
  class Engine < Rails::Engine
    
    
    config.autoload_paths += %W(#{config.root}/lib)
    
    # TODO - register state monitor observer?

    def self.activate
      
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
    
    end

    config.to_prepare &method(:activate).to_proc

  end
end