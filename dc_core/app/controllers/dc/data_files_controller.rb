# encoding: utf-8
class Dc::DataFilesController < Dc::BaseController
  
  def index
    @view_name = "all_files"
    @data_files = DataFile.all
  end
  
  def pix_only
    @view_name = "only_pix"
    @data_files = DataFile.pix
    render :template => 'dc/data_files/index'
  end
  
  def data_only
    @view_name = "only_data"
    @data_files = DataFile.nopix
    render :template => 'dc/data_files/index'
  end
  
  def new
    @data_file = DataFile.new()
    @data_file.generate_default_dc_name
  end
  
  def show
    @data_file = DataFile.find( params[:id] )
  end
  
  def create
    @data_file = DataFile.new(params[:data_file])
    if @data_file.save
      redirect_to( dcr_data_files_path, :notice => 'Datei wurde erstellt.' )
    else
      redirect_to( dcr_data_files_path, :error => 'Fehler! .. Datei wurde nicht erstellt!' )
    end
  end
  
  def update
    @data_file = DataFile.find( params[:id] )
    if @data_file.update_attributes(params[:data_file])
      redirect_to( dcr_data_file_path(@data_file), :notice => 'Datei wurde geändert.' )
    else
      redirect_to( dcr_data_file_path(@data_file), :error => 'Fehler! .. Datei wurde nicht erstellt!' )
    end
  end
  
  def original
    @data_file = DataFile.find( params[:id] )
    send_file @data_file.file.to_file( "tmp/dc_files/#{@data_file.original_name.to_s}" )
  end
  
  def destroy
    @data_file = DataFile.find( params[:id] )
    @data_file.destroy
    respond_to do |format|
      format.js   { render :nothing => true }
      format.html { redirect_to dcr_data_files_path, :notice => "Successfully destroyed page." }
    end
  end
  
end