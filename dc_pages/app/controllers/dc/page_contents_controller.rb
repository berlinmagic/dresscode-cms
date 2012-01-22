# encoding: utf-8
class Dc::PageContentsController < Dc::BaseController
  
  before_filter :load_data
  
  def new
    @page_content = PageContent.new
  end
  
  def create
    @page_content = PageContent.new(params[:page_content])
    if @page_content.save
      redirect_to dcr_page_path(@data.page_row.page.id), :notice => "Successfully created telement."
    else
      render :action => 'new'
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