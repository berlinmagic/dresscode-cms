class Dc::RastersController < Dc::BaseController
  
  before_filter :authorized_admin, :except => :get_raster
  
  caches_page :get_raster
  
  def index
    @rasters = Raster.all
  end

  def show
    @dc_full_view = true
    @raster = Raster.find(params[:id])
  end

  def new
    @raster = Raster.new
  end

  def create
    @raster = Raster.new(params[:raster])
    if @raster.save
      redirect_to @raster, :notice => "Successfully created raster."
    else
      render :action => 'new'
    end
  end

  def edit
    @raster = Raster.find(params[:id])
  end

  def update
    @raster = Raster.find(params[:id])
    if @raster.update_attributes(params[:raster])
      redirect_to @raster, :notice  => "Successfully updated raster."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @raster = Raster.find(params[:id])
    @raster.destroy
    redirect_to rasters_url, :notice => "Successfully destroyed raster."
  end
  
  def get_raster
    @raster = Raster.find(params[:id])
  end
  
end
