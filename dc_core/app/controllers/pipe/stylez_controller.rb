# encoding: utf-8
class Pipe::StylezController < ApplicationController
  
  include DcStylesHelp
  include CacheBase
  
  layout 'pipe/style'
  
  caches_page :public,            :if => :do_page_cache?
  caches_page :dc_style,          :if => :do_page_cache?
  caches_page :library,           :if => :do_page_cache?
  caches_page :dynamic_template,  :if => :do_page_cache?
  caches_page :dynamic_dc_style,  :if => :do_page_cache?
  caches_page :library,           :if => :do_page_cache?
  caches_page :plugin,            :if => :do_page_cache?
  
  # Public styles named by theme, so can be cached 
  def public
    @theme = params[:theme]
    cache_headers( DC::Config[:stylez_ttl].to_i )
    respond_with_etag( [@theme, DC::Config[:stylez_fresh]] ) do
      respond_to do |format|
        format.css { render :template => "pipe/stylez/app/public" }
      end
    end
  end
  
  # System Styles, wan´t change per theme
  def dc_style
    cache_headers( DC::Config[:stylez_ttl].to_i )
    respond_with_etag( DC::Config[:stylez_fresh].to_s ) do
      respond_to do |format|
        format.css { render :template => "pipe/stylez/app/dc" }
      end
    end
  end
  
  # Librarys .. to load and compress single or bundled style (eg. for fallback)
  def library
    @style = params[:style]
    @styles = @style.split('_')
    cache_headers( DC::Config[:library_ttl].to_i )
    respond_with_etag( [@style, DC::Config[:library_fresh]] ) do
      respond_to do |format|
        format.js { render :template => "pipe/stylez/app/load_lib" }
      end
    end
  end
  def plugin
    @style = params[:style]
    @styles = @style.split('_')
    cache_headers( DC::Config[:library_ttl].to_i )
    respond_with_etag( [@style, DC::Config[:library_fresh]] ) do
      respond_to do |format|
        format.js { render :template => "pipe/stylez/app/load_plugin" }
      end
    end
  end
  
  
  #
  def dynamic_template
    @tlayout = Tlayout.find(params[:id]) if params[:id]
    cache_headers( DC::Config[:dynamic_ttl].to_i )
    respond_with_etag( [ @tlayout, DC::Config[:dynamic_fresh] ] ) do
      respond_to do |format|
        format.css { render :template => 'pipe/stylez/theme_dynamic/template' }
      end
    end
  end
  
  def dynamic_dc_style
    @style = params[:style]
    cache_headers( DC::Config[:dynamic_ttl].to_i )
    respond_with_etag( [ @style, DC::Config[:dynamic_fresh] ] ) do
      respond_to do |format|
        format.css { render :template => "pipe/stylez/theme_dynamic/#{ @style }" }
      end
    end
  end
  
end