# encoding: utf-8
class EditorPipeController < ActionController::Base
  
  include DcStylesHelp
  include CoffeeScript
  include CacheBase
  
  caches_page :load_editor_pipe,  :if => :editor_do_page_cache?
  
  
  def load_editor_pipe
    @source = params[ :requested_source ]
    cache_headers_for( "editor" )
    respond_with_etag_for( "editor", [ @source, DC::Config[:editor_fresh] ] ) do
      respond_to do |format|
        format.js  { render :layout => 'pipe/script', :template => "piped_editor/scriptz/script" }
        format.css { render :layout => 'pipe/style',  :template => "piped_editor/stylez/style" }
      end
    end
  end
  
  
  # Load hole directories .. not nice .. should be updated, some time !
  def load_da_source_dir(path)
    @da_stuff = ''
    if File.exists?( File.join("#{ DcMercury::Engine.root }/app/views/", "#{ path }") )
      Dir.glob( File.join(File.expand_path("#{DcMercury::Engine.root}/app/views/#{ path }", __FILE__), "*.*") ) do |file|
        dafile = File.basename(file.to_s).gsub(/^_/, '')
        dafile = dafile.gsub(/.js.erb$/, '').gsub(/.js.coffee$/, '').gsub(/.css.erb$/, '').gsub(/.css$/, '').gsub(/.js$/, '')
        @da_stuff += render_to_string( :partial => "#{path}/#{ dafile.to_s }" )
      end
    end
    @da_stuff.to_s
  end
  helper_method :load_da_source_dir
  
end