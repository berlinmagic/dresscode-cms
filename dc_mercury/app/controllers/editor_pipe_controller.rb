# encoding: utf-8
class EditorPipeController < Dc::BaseController
  
  include DcStylesHelp
  include CoffeeScript
  
  
  def load_editor_pipe
    @source = params[ :requested_source ]
    respond_to do |format|
      format.js  { render :layout => 'pipe/script', :template => "piped_editor/scriptz/script" }
      format.css { render :layout => 'pipe/style',  :template => "piped_editor/stylez/style" }
    end
  end
  
  def load_da_source_dir(path)
    da_stuff = ''
    if File.exists?( File.join("#{DcMercury::Engine.root}/views/", "#{ path }") )
      Dir.glob( File.join( File.expand_path( "#{DcMercury::Engine.root}/views/", "#{path}" )  ) do |file|
        da_stuff += raw( render :partial => "#{path}/#{ file }" )
      end
    end
    da_stuff
  end
  
  helper_method :load_da_source_dir
  
end