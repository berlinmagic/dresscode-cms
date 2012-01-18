module DcThemesStatic
  module GemedThemes
    require 'singleton'
    # Listener class used for views hooks.
    class ThemeListener
      include Singleton
    
      attr_accessor :theme_gems
      
      def self.theme_init?
        false
      end

      def initialize
        @theme_gems = []
      end
      
    end
  end
end