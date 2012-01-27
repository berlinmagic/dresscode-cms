# encoding: utf-8
class PublicController < BaseController
  
  ### Controller for all stuff that is for guest-visitors
  
  def show_page
    this_slug = params[:full_slug].to_s.to_slash
    @page = Page.find_by_full_slug(this_slug) || Page.find_by_slug(this_slug) || false
    render_this_site
  end
  
  def root_page
    @page = Page.find_by_system_name( 'start' ) || false
    render_this_site
  end
  
  
  def render_seiten_error
    redirect_to(root_path, :flash => { :error => I18n.t('seite_nicht_vorhanden') + ".. #{params[:full_slug].to_s}" })
  end
  
  def render_this_site
    if @page
      @title = @page.title
      @headline = @page.headline
      if @page.is_deleted?
        render_seiten_error
      else
        render :layout => 'public', :template => 'public/page'
      end
    else
      render_seiten_error
    end
  end
  
  
end