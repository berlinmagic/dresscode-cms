class Dc::TlayoutsController < Dc::BaseController
  
  
  def index
    @tlayouts = Tlayout.all
  end

  def show
    @dc_full_view = true
    @tlayout = Tlayout.find(params[:id])
  end

  def new
    @tlayout = Tlayout.new
  end

  def create
    @tlayout = Tlayout.new(params[:tlayout])
    if @tlayout.save
      redirect_to @tlayout, :notice => "Successfully created tlayout."
    else
      render :action => 'new'
    end
  end

  def edit
    # => @dc_full_view = true
    @tlayout = Tlayout.find(params[:id])
  end

  def update
    @tlayout = Tlayout.find(params[:id])
    if @tlayout.update_attributes(params[:tlayout])
      redirect_to @tlayout, :notice  => "Successfully updated tlayout."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @tlayout = Tlayout.find(params[:id])
    @tlayout.destroy
    redirect_to tlayouts_url, :notice => "Successfully destroyed tlayout."
  end
  
  def reorder_zeilen
    logger.info "INFO: Get Reorder"
    logger.info "INFO: #{params.to_s}"
    if params[:sort]
      params[:sort].split(',').each_with_index do |s, i|
        row = Telement.by_cmsid(s).first
        row.position = i + 1
        row.save!
        logger.info "#{s} => #{i}"
      end
    end
    render :nothing => true
  end
  
  def mercury_update
    the_layout = Tlayout.find(params[:id])
    all_content = params[:content]
    all_content.each do |key,val|
      xx = Tcontent.by_cmsid( key ).first
      xx.text_content = val[:value]
      if xx.save
        logger.info " Content - #{key} = saved !!!"
      end
    end
    logger.info "#{ params[:content] }"
    render :text => ""
  end
  
  
end
