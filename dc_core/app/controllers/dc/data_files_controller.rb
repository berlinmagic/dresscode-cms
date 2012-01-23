# encoding: utf-8
class Dc::DataFilesController < Dc::BaseController
  
  def index
    @data_files = DataFile.all
  end
  
  def new
    @data_file = DataFile.new()
  end
  
  def create
    @data_file = DataFile.new(params[:data_file])
    if @data_file.save
      redirect_to( dcr_data_files_path, :notice => 'Datei wurde erstellt.' )
    else
      render :action => 'new'
    end
  end
  
end