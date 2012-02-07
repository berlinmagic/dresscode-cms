# encoding: utf-8
class PublicCartesController < BaseController
  
  ### Controller for all stuff that is for guest-visitors
  
  def index
    @page = Page.where( :system_name => 'carte' ).first
    @cartes = Carte.all
    render_this_site
  end
  
  
  def show_carte_page
    @page = Page.where( :system_name => 'carte' ).first
    render_this_site
  end
  
  def show_carte
    @carte = Carte.where( :slug => '/' + params[:carte] ).first if params[:carte]
    @sub_carte = SubCarte.where( :slug => '/' + params[:sub_carte] ).first if params[:sub_carte]
    @carte_entry = CarteEntry.where( :slug => '/' + params[:carte_entry] ).first if params[:carte_entry]
    @page = Page.where( :system_name => 'carte' ).first
    render_this_site
  end
  
  
  def render_seiten_error
    redirect_to(root_path, :flash => { :error => I18n.t('seite_nicht_vorhanden') + ".. #{params[:full_slug].to_s}" })
  end
  
  def render_this_site
    if @page
      @title = "#{@carte.name if @carte} - #{@sub_carte.name if @sub_carte} - #{@carte_entry.headline if @carte_entry} - Site"
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