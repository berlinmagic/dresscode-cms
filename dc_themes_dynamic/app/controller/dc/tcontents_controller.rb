class Dc::TcontentsController < Dc::BaseController
  
  before_filter :load_data
  
  def index
    @tcontents = Tcontent.all
  end

  def show
    @tcontent = Tcontent.find(params[:id])
  end

  def new
    @tcontent = Tcontent.new
  end

  def create
    @tcontent = Tcontent.new(params[:tcontent])
    if @tcontent.save
      if @data
        if @objekt_type == 'Tlayout'
          @tcontent.this_layout = @objekt_id
        else
          @tcontent.this_layout = @data.this_layout
        end
        @tcontent.save
        redirect_to dc_tlayout_path(@tcontent.this_layout), :notice => "Element wurde erstellt."
      else
        redirect_to @tcontent, :notice => "Element wurde erstellt."
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @tcontent = Tcontent.find(params[:id])
  end

  def update
    @tcontent = Tcontent.find(params[:id])
    if @tcontent.update_attributes(params[:tcontent])
      
      if @telement.this_layout
        redirect_to dc_tlayout_path(@tcontent.this_layout), :notice => "Successfully updated content."
      else
        redirect_to @tcontent, :notice  => "Successfully updated content."
      end
    else
      render :action => 'edit'
    end
  end

  def destroy
    @tcontent = Tcontent.find(params[:id])
    @tcontent.destroy
    redirect_to tcontents_url, :notice => "Successfully destroyed tcontent."
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
