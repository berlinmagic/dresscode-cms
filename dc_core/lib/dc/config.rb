# encoding: utf-8
## => inspired by Spree  (  https://github.com/spree/spree  &  http://spreecommerce.com/  )  ... thanks a lot !!!
module DC
  require 'singleton'
  # Singleton class to access the configuration object (CoreConfiguration.first by default) and its preferences.
  # Usage:
  #   DC::Config[:foo]                  # Returns the +foo+ preference
  #   DC::Config[]                      # Returns a Hash with all the application preferences
  #   DC::Config.instance               # Returns the configuration object (AppConfiguration.first)
  #   DC::Config.set(preferences_hash)  # Set the application preferences as especified in +preference_hash+
  #   DC::Config.searcher/searcher=     # get/set the default product search implementation
  class Config
    include Singleton
    include DC::PreferenceAccess

    class << self
      def instance
        return @configuration if @configuration
        return nil unless ActiveRecord::Base.connection.tables.include?('configurations')
        @configuration ||= CoreConfiguration.find_or_create_by_name("Default configuration")
        @configuration
      end
      
    end
  end
end