module DcStaticthemes
  module GemedThemes
    module GemTheme

      @@gem_theme_classes = []
      @@gemed_themes = nil

      class << self
        # Adds a listener class.
        # Automatically called when a class inherits from Spree::ThemeSupport::HookListener.
        def add_gemed_theme(klass)
          raise "Hooks must include Singleton module." unless klass.included_modules.include?(Singleton)
          @@gem_theme_classes << klass
          clear_listeners_instances
        end

        # Returns all the listerners instances.
        def gemed_themes
          @@gemed_themes ||= @@gem_theme_classes.uniq.collect {|listener| listener.instance}
        end

        # Clears all the listeners.
        def clear_gemed_theme
          @@gem_theme_classes = []
          clear_gemed_theme_instances
        end
        
        # Clears all the listeners instances.
        def clear_gemed_theme_instances
          @@gemed_themes = nil
        end
    
      end
      
    end
    
  end
end