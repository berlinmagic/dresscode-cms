class Dc::TagListsController < Dc::BaseController
  
  before_filter :load_data
  
  def index
    @tag_lists = TagList.all
  end

  def show
    @tag_list = TagList.find(params[:id])
  end

  def new
    @tag_list = TagList.new
  end

  def create
    @tag_list = TagList.new(params[:tag_list])
    if @tag_list.save
      redirect_to @tag_list.class, :notice => "Successfully created tag list."
    else
      render :action => 'new'
    end
  end

  def edit
    @tag_list = TagList.find(params[:id])
  end

  def update
    @tag_list = TagList.find(params[:id])
    if @tag_list.update_attributes(params[:tag_list])
      redirect_to @tag_list.class, :notice  => "Successfully updated tag list."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @tag_list = TagList.find(params[:id])
    @tag_list.destroy
    redirect_to tag_lists_url, :notice => "Successfully destroyed tag list."
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
