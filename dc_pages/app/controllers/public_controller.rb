# encoding: utf-8
class PublicController < BaseController
  
  ### Controller for all stuff that is for guest-visitors
  
  def show_seite
    this_slug = params[:full_slug].to_s.to_slash
    @page = Page.find_by_full_slug(this_slug) || Page.find_by_slug(this_slug) || false
    if @page
      @title = @page.title
      @headline = @page.headline
      render_this_site
    else
      render_seiten_error
    end
  end
  
  
  def render_seiten_error
    # => render :text => 'What the fuck are you looking for ... Bastard?', :status => :not_found
    redirect_to(root_path, :flash => { :error => I18n.t('seite_nicht_vorhanden') + ".. #{params[:full_slug].to_s}" })
  end
  
  def render_this_site
    if @page.is_deleted?
      render_seiten_error
    else
      render :layout => 'public', :template => 'pages/show'
    end
  end
  
end