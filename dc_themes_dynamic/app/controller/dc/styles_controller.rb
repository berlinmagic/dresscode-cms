class Dc::StylesController < Dc::BaseController
  
  before_filter :load_data
  
  def index
    @styles = Style.all
  end

  def show
    @style = Style.find(params[:id])
  end

  def new
    @style = Style.new
  end

  def create
    @style = Style.new(params[:style])
    if @style.save
      if @data
        if @data.this_layout
          redirect_to dc_tlayout_path(@data.this_layout), :notice => "Successfully created Style."
        else
          redirect_to [:dc, @style], :notice => "Successfully created style."
        end
      else
        redirect_to [:dc, @style], :notice => "Successfully created style."
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @style = Style.find(params[:id])
  end

  def update
    @style = Style.find(params[:id])
    if @style.update_attributes(params[:style])
      redirect_to [:dc, @style], :notice  => "Successfully updated style."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @style = Style.find(params[:id])
    @style.destroy
    redirect_to dc_styles_url, :notice => "Successfully destroyed style."
  end
  
  def load_data
    @id_muster = /\w+_id/
    params.each do |key,value|
        if @id_muster.match(key)
          @objekt_type = key.gsub('_id', '').classify
          @objekt_id = value
          @data = @objekt_type.constantize.find(@objekt_id)
        end
    end
  end
  
end
