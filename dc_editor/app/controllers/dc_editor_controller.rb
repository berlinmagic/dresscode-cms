class DcEditorController < ActionController::Base
  protect_from_forgery
  
  include GlobalUser
  
  before_filter :authorized_admin

  layout false

  def edit
    render :text => '', :layout => 'dc_editor'
  end

  def resource
    render :action => "/#{params[:type]}/#{params[:resource]}"
  end

  def snippet_options
    @options = params[:options] || {}
    render :action => "/snippets/#{params[:name]}/options"
  end

  def snippet_preview
    render :action => "/snippets/#{params[:name]}/preview"
  end

  def test_page
    render :text => params
  end
  

end
