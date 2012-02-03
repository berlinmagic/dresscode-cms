# encoding: utf-8
class Dc::SubCartesController < Dc::BaseController
  
  before_filter :find_parent_carte
  
  def index
    @sub_cartes = Carte.all
  end
  
  def show
    @sub_carte = SubCarte.find( params[:id] )
  end
  
  def new
    @sub_carte = SubCarte.new()
  end
  
  def create
    @sub_carte = SubCarte.new( params[:sub_carte] )
    @sub_carte.carte = @carte if @carte
    if @sub_carte.save
      if @carte
        redirect_to dcr_carte_path( @carte ), :notice => I18n.t("dc.cartes.flash.create_success")
      else
        redirect_to dcr_cartes_path, :notice => I18n.t("dc.cartes.flash.create_success")
      end
    else
      render :action => :new, :alert => I18n.t("dc.cartes.flash.create_error")
    end
  end
  
  def find_parent_carte
    if params[:carte_id]
      @carte = Carte.find( params[:carte_id] )
    end
  end
  
end