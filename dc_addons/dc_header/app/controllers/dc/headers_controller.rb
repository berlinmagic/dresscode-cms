# encoding: utf-8
class Dc::HeadersController < Dc::BaseController
  
  def index
    @headers = Header.all
  end
  
  def show
    @header = Header.find( params[:id] )
  end
  
  def new
    @header = Header.new
  end
  
  def edit
    @header = Header.find( params[:id] )
  end
  
  def create
    @header = Header.new( params[:header] )
    if @header.save
      redirect_to dcr_header_path( @header ), :notice => I18n.t("dc.headers.flash.create_success")
    else
      render :action => :new, :alert => I18n.t("dc.headers.flash.create_error")
    end
  end
  
  def update
    @header = Header.find( params[:id] )
    if @header.update_attributes( params[:header] )
      redirect_to dcr_header_path( @header ), :notice => I18n.t("dc.headers.flash.update_success")
    else
      render :action => :new, :alert => I18n.t("dc.headers.flash.update_error")
    end
  end
  
  
  def new_pic
    @header = Header.find( params[:id] )
    @data_file = DataFile.new
  end
  
  def new_pic_up
    @header = Header.find( params[:id] )
    @data_file = DataFile.new( :file => params[:file] )
    if @data_file.save
      @attachment = Attachment.create!( :target_type => 'Header', :target_id => @header.id, :data_file_id => @data_file.id )
      redirect_to( crop_pic_dcr_header_path( @header, @attachment ), :notice => 'Datei wurde erstellt.' )
    else
      redirect_to( dcr_header_path( @header ), :alert => 'Fehler! .. Datei wurde nicht erstellt!' )
    end
  end
  
  def crop_pic
    @header = Header.find( params[:id] )
    @attachment = Attachment.find( params[:pic] )
  end
  
  def crop_up
    redirect_to( dcr_header_path( @header ), :alert => 'Fehler! .. Funktion nicht fertig !' )
  end
  
end