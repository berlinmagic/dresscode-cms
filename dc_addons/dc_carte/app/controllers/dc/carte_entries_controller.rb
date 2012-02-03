# encoding: utf-8
class Dc::CarteEntriesController < Dc::BaseController
  
  def index
    @carte_entries = CarteEntry.all
  end
  
  def show
    @carte_entry = CarteEntry.find( params[:id] )
  end
  
  def new
    @carte_entry = CarteEntry.new()
  end
  
  def create
    @carte_entry = CarteEntry.new( params[:carte_entry] )
    if @carte_entry.save
      redirect_to dcr_carte_entries_path, :notice => I18n.t("dc.carte_entries.flash.create_success")
    else
      render :action => :new, :alert => I18n.t("dc.carte_entries.flash.create_error")
    end
  end
  
  def destroy
    @carte_entry = CarteEntry.find( params[:id] )
    @carte_entry.destroy
    respond_to do |format|
      format.js   { render :nothing => true }
      format.html { redirect_to dcr_carte_entries_path, :notice => I18n.t("dc.carte_entries.flash.deleted_success") }
    end
  end
  
end