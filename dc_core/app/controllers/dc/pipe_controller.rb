# encoding: utf-8
class Dc::PipeController < ApplicationController
  
  include DcStylesHelp
  include CoffeeScript
  
  caches_page :dynamic_style
  caches_page :dynamic_script
  caches_page :template_style
  
  def dynamic_style
      @style4 = params[:to_style] if params[:to_style]
      respond_to do |format|
        format.css { render :template => 'dc/pipe/css/app' }
      end
  end
  
  def template_style
      @tlayout = Tlayout.find(params[:id]) if params[:id]
      respond_to do |format|
        format.css { render :template => 'dc/pipe/css/template' }
      end
  end
  
  def dynamic_script
      @script = params[:script]
      respond_to do |format|
        format.js { render :template => "dc/pipe/js/#{ @script }" }
      end
  end
  
  def dynamic_script_lib
    @script = params[:script]
    render :template => "dc/pipe/js/dep_loader"
  end
  
end