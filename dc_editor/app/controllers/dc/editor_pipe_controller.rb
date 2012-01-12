# encoding: utf-8
class Dc::EditorPipeController < Dc::BaseController
  
  include DcStylesHelp
  include CoffeeScript
  
  caches_page :load_editor_scripts
  caches_page :load_editor_styles
  # => caches_page :dynamic_script
  
  
  def load_editor_scripts
    render :template => "dc/pipe/js/editor_pipe"
  end
  
  def load_editor_styles
    render :template => "dc/pipe/css/editor_pipe"
  end
  
  
  def load_editor_loader_scripts
    render :template => "dc/pipe/js/dc_editor_loader"
  end
  
end