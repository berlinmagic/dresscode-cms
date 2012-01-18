class Dc::TelementsController < Dc::BaseController
  
  before_filter :load_data
  
  def index
    @telements = Telement.all
  end

  def show
    @telement = Telement.find(params[:id])
  end

  def new
    @telement = Telement.new
  end

  def create
    @telement = Telement.new(params[:telement])
    if @telement.save
      if @telement.element_type == "grid_row"
        if params[:telement][:spalten] && params[:telement][:spalten].to_i > 0
          params[:telement][:spalten].to_i.times do |x|
            Telement.create!( 
                :columns => (@telement.columns / params[:telement][:spalten].to_i), 
                :telement_id => @telement.id,
                :this_layout => @telement.this_layout,
                :element_type => 'grid_cell',
                :tag_list_id => 1,
                :position => x
              )
          end
        end
      end
      if @data
        if @objekt_type == 'Tlayout'
          @telement.this_layout = @objekt_id
        else
          @telement.this_layout = @data.this_layout
        end
        @telement.save
        redirect_to dc_tlayout_path(@telement.this_layout), :notice => "Successfully created telement."
      else
        redirect_to @telement, :notice => "Successfully created telement."
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @telement = Telement.find(params[:id])
  end

  def update
    @telement = Telement.find(params[:id])
    if @telement.update_attributes(params[:telement])
      if @telement.this_layout
        redirect_to dc_tlayout_path(@telement.this_layout), :notice => "Successfully updated telement."
      else
        redirect_to @telement, :notice  => "Successfully updated telement."
      end
    else
      render :action => 'edit'
    end
  end

  def destroy
    @telement = Telement.find(params[:id])
    @telement.destroy
    
    respond_to do |format|
      format.html { redirect_to telements_url, :notice => "Successfully destroyed telement." }
      format.json { render :nothing => true }
    end
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
