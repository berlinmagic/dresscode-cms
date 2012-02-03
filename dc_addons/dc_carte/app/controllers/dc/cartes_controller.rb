# encoding: utf-8
class Dc::CartesController < Dc::BaseController
  
  def index
    @cartes = Carte.all
  end
  
  def show
    @carte = Carte.find( params[:id] )
  end
  
  def new
    @carte = Carte.new()
  end
  
  def create
    @carte = Carte.new( params[:carte] )
    if @carte.save
      redirect_to dcr_cartes_path, :notice => I18n.t("dc.cartes.flash.create_success")
    else
      render :action => :new, :alert => I18n.t("dc.cartes.flash.create_error")
    end
  end
  
end