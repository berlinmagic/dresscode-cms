# encoding: utf-8
class Dc::PagesController < Dc::BaseController
  
  
  def index
    @pages = Page.main
  end

  def show
    @page = Page.find(params[:id])
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(params[:page])
    if @page.save
      redirect_to( dcr_page_path( @page ), :notice => 'Seite wurde erstellt und kann bearbeitet werden.' )
    else
      render :action => 'new'
    end
  end

  def edit
    @page = Page.find(params[:id])
    render :layout => 'dc', :template => 'dc/pages/edit'
  end

  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(params[:page])
      redirect_to( dcr_page_path( @page ), :notice => 'Seite wurde geändert und kann nun weiter bearbeitet werden.' )
    else
      render :action => 'edit'
    end
  end

  def destroy
    @page = Page.find(params[:id])
    @page.deleted_at = Time.now()
    @page.save
    redirect_to dcr_pages_url, :notice => "Successfully deleted page."
  end
  
  def mercury_update
    page = Page.find(params[:id])
    params[:content].each do |key, value|
      if ( key =~ /pcon_(.*)/ )
        pcontent = PageContent.dcid(key).first
        if pcontent
          pcontent.text_content = value[:value]
          pcontent.save!
          logger.info "Content-Cell::  #{value[:value]}"
        end
      end
    end
    if page.save
      logger.info " Page = saved !!!"
    end
    render :text => ""
  end
  
  
  def reorder_rows
  end
  
  def reorder_cells
  end
  
  def reorder_pages
    pages = params[:pages] ? ActiveSupport::JSON.decode( params[:pages] ) : []
    logger.info " #{ pages.to_yaml } "
    if pages && pages.kind_of?(Array)
      pages.each_with_index do |key, index|
        da_page = Page.find( key['id'] )
        logger.info "XXX:: #{ index } => #{ key.to_s } .. #{ da_page.name } "
        da_page.position = index
        da_page.parent_site_id = nil
        da_page.save
        if key['children']
          order_child_sites( key['children'], key['id'] )
        end
      end
    end
    logger.info " #{ ActiveSupport::JSON.decode( params[:pages] ).to_yaml } "
    render :nothing => true
  end
  
  def show_editable_page
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
  
  def show_editable_root
    @page = Page.where(:system_name => 'start').first
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
    redirect_to(dcr_root_path, :flash => { :error => I18n.t('seite_nicht_vorhanden') })
  end
  
  def render_this_site
    if @page.is_deleted?
      render_seiten_error
    else
      render :layout => 'dc', :template => 'dc/pages/show'
    end
  end
  
  def order_child_sites(sites, parent)
    if sites && sites.kind_of?(Array)
      sites.each_with_index do |key, index|
        da_page = Page.find( key['id'] )
        logger.info "XXX:: #{ parent } #{ index } => #{ key.to_s } .. #{ da_page.name } "
        da_page.position = index
        da_page.parent_site_id = parent
        da_page.save
        if key['children']
          order_child_sites( key['children'], key['id'] )
        end
      end
    end
  end
  
end
