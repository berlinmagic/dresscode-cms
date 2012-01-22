# encoding: utf-8
class Dc::PagesController < Dc::BaseController
  
  
  def index
    @pages = Page.all
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
    render :layout => themed_path('dc'), :template => 'dc/pages/edit'
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
    @page.destroy
    redirect_to dcr_pages_url, :notice => "Successfully destroyed page."
  end
  
  def mercury_update
    page = Page.find(params[:id])
    params[:content].each do |key, value|
      if key == 'page_content'
        page.text_content = value[:value]
        logger.info "Text-Content::  #{value[:value]}"
      elsif ( key =~ /pcon_(.*)/ )
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
  
  
  def show_seite
      if params[:system_name]
        if Page.where(:system_name => params[:system_name]).count > 0
          @page = Page.where(:system_name => params[:system_name]).first
        end
      elsif params[:id]
        if Seite.find(params[:id])
          @page = Seite.find(params[:id])
        end
      elsif params[:slug]
        if Page.find_by_slug(params[:slug]) || Page.find_by_slug('/'+params[:slug]) || Page.find_by_name(params[:slug])
          @page = Page.find_by_slug(params[:slug]) || Page.find_by_slug('/'+params[:slug]) || Page.find_by_name(params[:slug])
        end
      elsif params[:slug1]
        this_full_slug = "/#{params[:slug1]}#{ '/' + params[:slug2] if params[:slug2] }#{ '/' + params[:slug3] if params[:slug3] }#{ '/' + params[:slug4] if params[:slug4] }"
        this_name = params[:slug1]
        this_name = params[:slug2] if params[:slug2]
        this_name = params[:slug3] if params[:slug3]
        this_name = params[:slug4] if params[:slug4]
        this_slug = "/#{this_name}"
        if Page.find_by_full_slug(this_full_slug) || Page.find_by_slug(this_slug) || Page.find_by_std_slug(this_slug) || Seite.find_by_name(this_name)
          @page = Page.find_by_full_slug(this_full_slug) || Page.find_by_slug(this_slug) || Page.find_by_std_slug(this_slug) || Page.find_by_name(this_name)
        end
      end
      if @page
        @title = @page.title
        @headline = @page.headline
        render_this_site
      else
        render_seiten_error
      end
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
      render :layout => themed_path('dc'), :template => 'dc/pages/show'
    end
  end
  
end
