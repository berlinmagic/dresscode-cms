# encoding: utf-8
class Pipe::ScriptzController < ApplicationController
  
  include DcStylesHelp
  include CoffeeScript
  
  include CacheBase
  
  layout 'pipe/script'
  
  caches_page :public,  :if => :do_page_cache?
  caches_page :dc_js,   :if => :do_page_cache?
  caches_page :library, :if => :do_page_cache?
  caches_page :dtheme,  :if => :do_page_cache?
  
  # Public Scriptz named by theme, so can be cached 
  def public
    @theme = params[:theme]
    cache_headers( DC::Config[:scriptz_ttl].to_i )
    respond_with_etag( [@theme, DC::Config[:scriptz_fresh]] ) do
      respond_to do |format|
        format.js { render :template => "pipe/scriptz/app/public" }
      end
    end
  end
  
  # System Scriptz, wan´t change per theme
  def dc_js
    cache_headers( DC::Config[:scriptz_ttl].to_i )
    respond_with_etag( DC::Config[:scriptz_fresh] ) do
      respond_to do |format|
        format.js { render :template => "pipe/scriptz/app/dc" }
      end
    end
  end
  
  # Librarys .. to load and compress single or bundled Scriptz (eg. for fallback)
  def library
    @script = params[:script]
    @scripts = @script.split('_')
    cache_headers( DC::Config[:library_ttl].to_i )
    respond_with_etag( [@script, DC::Config[:library_fresh]] ) do
      respond_to do |format|
        format.js { render :template => "pipe/scriptz/app/load_libs" }
      end
    end
  end
  def plugin
    @script = params[:script]
    @scripts = @script.split('_')
    cache_headers( DC::Config[:library_ttl].to_i )
    respond_with_etag( [@script, DC::Config[:library_fresh]] ) do
      respond_to do |format|
        format.js { render :template => "pipe/scriptz/app/load_plugins" }
      end
    end
  end
  
  
  # scripts for dynamic-themes:
  def dtheme
    cache_headers( DC::Config[:dynamic_ttl].to_i )
    respond_with_etag( DC::Config[:dynamic_fresh] ) do
      respond_to do |format|
        format.js { render :template => "pipe/scriptz/theme_dynamic/dc_dynamic" }
      end
    end
  end
  
  
end