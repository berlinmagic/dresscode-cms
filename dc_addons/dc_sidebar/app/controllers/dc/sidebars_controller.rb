# encoding: utf-8
class Dc::SidebarsController < Dc::BaseController
  
  def index
    @sidebars = Sidebar.all
  end
  
  def show
    @sidebar = Sidebar.find( params[:id] )
  end
  
  def new
    @sidebar = Sidebar.new()
  end
  
  def create
    @sidebar = Sidebar.new( params[:sidebar] )
    if @sidebar.save
      redirect_to dcr_sidebars_path, :notice => I18n.t("dc.sidebars.flash.create_success")
    else
      render :action => :new, :alert => I18n.t("dc.sidebars.flash.create_error")
    end
  end
  
end