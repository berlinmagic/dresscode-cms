# encoding: utf-8
class Dc::PipeController < ApplicationController
  
  # => ****************************************************************************
  # => Outdated ... use pipe/style or script controller !!!"
  # => ****************************************************************************
  
  include DcStylesHelp
  include CoffeeScript
  
  caches_page :dynamic_style
  caches_page :dynamic_script
  caches_page :template_style
  
  layout false
  
  def dynamic_style
    logger.info '****************************************************************************'
    logger.info "Outdated ... use pipe/style_controller !!!"
    logger.info '****************************************************************************'
      @style4 = params[:to_style] if params[:to_style]
      respond_to do |format|
        format.css { render :template => 'dc/pipe/css/app' }
      end
  end
  
  def template_style
    logger.info '****************************************************************************'
    logger.info "Outdated ... use pipe/style_controller !!!"
    logger.info '****************************************************************************'
      @tlayout = Tlayout.find(params[:id]) if params[:id]
      respond_to do |format|
        format.css { render :template => 'dc/pipe/css/template' }
      end
  end
  
  def dynamic_script
    logger.info '****************************************************************************'
    logger.info "Outdated ... use pipe/script_controller !!!"
    logger.info '****************************************************************************'
      @script = params[:script]
      respond_to do |format|
        format.js { render :template => "dc/pipe/js/#{ @script }" }
      end
  end
  
  def dynamic_script_lib
    logger.info '****************************************************************************'
    logger.info "Outdated ... use pipe/script_controller !!!"
    logger.info '****************************************************************************'
    @script = params[:script]
    render :template => "dc/pipe/js/dep_loader"
  end
  
end