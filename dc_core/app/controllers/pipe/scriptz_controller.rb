# encoding: utf-8
class Pipe::ScriptzController < ApplicationController
  
  include DcStylesHelp
  include CoffeeScript
  
  layout 'pipe/script'
  
  # => caches_page :library, :if => DC::Config[:cache_method] == 'page_cache'
  
  # Public Scriptz named by theme, so can be cached 
  def public
    
  end
  
  # System Scriptz, wan´t change per theme
  def dc_js
    
  end
  
  # Librarys .. to load and compress single or bundled Scriptz (eg. for fallback)
  def library
    @script = params[:script]
    if DC::Config[:cache_method] == 'header_cache'
      cache_time = cache_time_for_mod( DC::Config[:js_library_ttl].to_i )
      if DC::Config[:varnish_enabled]
        # => set_cache_ttl( cache_time ) # for dc_lacquer
      else
        response.header['Cache-Control'] = "public, max-age=#{ cache_time }"
        response.header['Expires'] = CGI.rfc1123_date(Time.now + cache_time)
      end
    end
    if DC::Config[:etags_enabled]
      if stale?( :etag => @script ) # maybe: DC::Config[:library_date]
        respond_to do |format|
          format.js { render :template => "pipe/scriptz/libraries/#{ @script }" }
        end
      end
    else
      respond_to do |format|
        format.js { render :template => "pipe/scriptz/libraries/#{ @script }" }
      end
    end
  end
  
  def cache_time_for_mod(that_time)
    DC::Config[:production_mode] ? that_time.to_i : DC::Config[:dev_mode_ttl].to_i
  end
  
end