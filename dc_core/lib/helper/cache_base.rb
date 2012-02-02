# encoding: utf-8
module CacheBase
  module InstanceMethods
    
    # old Helper-Methods
    def do_page_cache?
      if DC::Config[:cache_method] == 'page_cache'
        true
      else
        false
      end
    end
    
    def cache_headers( time = 0 )
      if DC::Config[:cache_method] == 'header_cache'
        cache_time = cache_time_for_mod( time )
        if DC::Config[:varnish_enabled]
          # => set_cache_ttl( cache_time ) # for dc_lacquer
        else
          response.header['Cache-Control'] = "public, max-age=#{ cache_time }"
          response.header['Expires'] = CGI.rfc1123_date(Time.now + cache_time)
        end
      end
    end
    
    def respond_with_etag( etags = nil )
      if DC::Config[:etags_enabled] && !etags.blank?
        if stale?( :etag => etags )
          yield
        end
      else
        yield
      end
    end
    
    ## new Helper-Method
    # this dosn't work :(
    #def do_page_cache_for( thing="" )
    #  if DC::Config[ "#{ thing.to_s + '_' if !thing.blank? }cache_method" ] == 'page_cache'
    #    true
    #  else
    #    false
    #  end
    #end
    
    def editor_do_page_cache?
      DC::Config[:editor_cache_method] == 'page_cache' ? true : false
    end
    def style_do_page_cache?
      DC::Config[:style_cache_method] == 'page_cache' ? true : false
    end
    def script_do_page_cache?
      DC::Config[:script_cache_method] == 'page_cache' ? true : false
    end
    def library_do_page_cache?
      DC::Config[:library_cache_method] == 'page_cache' ? true : false
    end
    def page_do_page_cache?
      DC::Config[:page_cache_method] == 'page_cache' ? true : false
    end
    def dynamic_do_page_cache?
      DC::Config[:dynamic_cache_method] == 'page_cache' ? true : false
    end
    
    def cache_headers_for( thing )
      if DC::Config["#{ thing.to_s + '_' if !thing.blank? }cache_method"] == 'header_cache'
        cache_time = cache_time_for_mod( DC::Config["#{ thing.to_s + '_' if !thing.blank? }ttl"] )
        # if DC::Config[:varnish_enabled]
        #   set_cache_ttl( cache_time ) # for dc_lacquer
        # else
          response.header['Cache-Control'] = "public, max-age=#{ cache_time }"
          response.header['Expires'] = CGI.rfc1123_date(Time.now + cache_time)
        # end
      end
    end
    
    def respond_with_etag_for( thing, etags = nil )
      if DC::Config["#{ thing.to_s + '_' if !thing.blank? }etags"] && !etags.blank?
        if stale?( :etag => etags )
          yield
        end
      else
        yield
      end
    end
    
    
    
  private
    
    def cache_time_for_mod( time )
      DC::Config[:production_mode] ? time.to_i : DC::Config[:dev_mode_ttl].to_i
    end
    
    
  end # < InstanceMethods

  def self.included(receiver)
    #receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    receiver.send :helper_method, 'do_page_cache?'
    receiver.send :helper_method, 'cache_headers'
    receiver.send :helper_method, 'respond_with_etag'
    # new
    #receiver.send :helper_method, 'do_page_cache_for'
    receiver.send :helper_method, 'editor_do_page_cache?'
    receiver.send :helper_method, 'style_do_page_cache?'
    receiver.send :helper_method, 'script_do_page_cache?'
    receiver.send :helper_method, 'library_do_page_cache?'
    receiver.send :helper_method, 'page_do_page_cache?'
    receiver.send :helper_method, 'dynamic_do_page_cache?'
    receiver.send :helper_method, 'cache_headers_for'
    receiver.send :helper_method, 'respond_with_etag_for'
  end
  
end