module DcCore
  class Engine < Rails::Engine
    
    
    config.autoload_paths += %W(#{config.root}/lib)
    
    initializer "static cache" do |app|
      if DC::Config[:cache_statics]
          Rails.application.middleware.insert_after Dragonfly::Middleware, Rack::DcStaticCache, 
                        :urls => ["/images", "/App_Themes"], 
                        :duration => DC::Config[:production_mode] ? DC::Config[:statics_ttl].to_i : DC::Config[:dev_mode_ttl].to_i, 
                        :root => "public"
      end
    end

    def self.activate
      
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
      
      HookSupport::HookListener.subclasses.each do |hook_class|
        HookSupport::Hook.add_listener(hook_class)
      end
      
      
    end

    config.to_prepare &method(:activate).to_proc
    
    
  end
end