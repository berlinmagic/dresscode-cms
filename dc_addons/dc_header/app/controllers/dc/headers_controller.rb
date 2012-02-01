# encoding: utf-8
class Dc::HeadersController < Dc::BaseController
  
  def index
    @headers = Header.all
    if @headers.count == 1
      redirect_to dcr_header_path( @headers.first )
    else
      render 'dc/headers/index'
    end
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
  
  def destroy
    @header = Header.find( params[:id] )
    @header.destroy
    respond_to do |format|
      format.js   { render :nothing => true }
      format.html { redirect_to dcr_headers_path, :notice => I18n.t("dc.headers.flash.deleted_success") }
    end
  end
  
  # => ###  Attachment - Actions  ############################################################################################
  
  def new_pic
    @header = Header.find( params[:id] )
    @data_file = DataFile.new
  end
  
  def new_pic_up
    @header = Header.find( params[:id] )
    @data_file = DataFile.new( :file => params[:file] )
    if @data_file.save
      @attachment = Attachment.create!( :target_type => 'Header', :target_id => @header.id, :data_file_id => @data_file.id )
      redirect_to( crop_pic_dcr_header_path( @header, @attachment ), :notice => I18n.t("dc.data_files.flash.create_success") )
    else
      redirect_to( dcr_header_path( @header ), :alert => I18n.t("dc.data_files.flash.create_error") )
    end
  end
  
  def crop_pic
    @header = Header.find( params[:id] )
    @attachment = Attachment.find( params[:pic] )
    @dc_full_view = true
  end
  
  def crop_up
    @header = Header.find( params[:id] )
    @attachment = Attachment.find( params[:pic] )
    if @attachment.update_attributes( params[:attachment] )
      redirect_to( dcr_header_path( @header ), :notice => I18n.t("dc.headers.flash.crop_success") )
    else
      redirect_to( dcr_header_path( @header ), :alert => I18n.t("dc.headers.flash.crop_error") )
    end
  end
  
  def remove_pic
    @header = Header.find( params[:id] )
    @attachment = Attachment.find( params[:pic] )
    @attachment.destroy
    respond_to do |format|
      format.js   { render :nothing => true }
      format.html { redirect_to( dcr_header_path( @header ), :notice => I18n.t("dc.headers.flash.pic_deleted") ) }
    end
  end
  
end