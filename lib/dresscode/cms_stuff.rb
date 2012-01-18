module Dresscode
  
  class << self
    attr_accessor :cms_stuff

    # Call this method to modify defaults in your initailizers.
    #
    #   Lacquer.configure do |config|
    #     config.varnish_servers << { :host => '0.0.0.0', :port => 6082, :timeout => 5 }
    #   end
    def configure
      self.cms_stuff ||= CmsStuff.new
      yield(cms_stuff)
    end
  end
  
  class CmsStuff
    OPTIONS = []

    attr_accessor :cache_method
    attr_accessor :varnish_enabled
    attr_accessor :etags_enabled
    attr_accessor :js_library_ttl
    attr_accessor :puclics_ttl
    attr_accessor :production_mode
    attr_accessor :dev_mode_ttl

    def initialize
      
      #CACHE_TYPES  =  ['none', 'page_cache', 'header_cache']
      #SYSTEM_MODS  =  ['development', 'production']
      @cache_method     =   'none'
      @varnish_enabled  =   false
      @etags_enabled    =   false
      # Cache Times
      @js_library_ttl   =   3600
      @puclics_ttl      =   3600
      # Dev-Mod & Times
      @production_mode  =   false
      @dev_mode_ttl     =   30
  
    end

    # Returns a hash of all configurable options
    def to_hash
      OPTIONS.inject({}) do |hash, option|
        hash.merge(option.to_sym => send(option))
      end
    end
  end
end
