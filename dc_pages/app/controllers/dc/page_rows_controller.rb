# encoding: utf-8
class Dc::PageRowsController < Dc::BaseController
  
  before_filter :load_data
  
  def new
    @page_row = PageRow.new
  end
  
  def create
    
    @page_row = PageRow.new(params[:page_row])
    if @page_row.save
      build_the_cells
      redirect_to dcr_page_path(@data), :notice => "Successfully created telement."
    else
      render :action => 'new'
    end
    
  end
  
  def load_data
    @id_muster = /\w+_id/
    params.each do |key,value|
        if @id_muster.match(key)
          @objekt_type = key.gsub('_id', '').classify
          @objekt_id = value
          @data = @objekt_type.constantize.find(@objekt_id)
        end
    end
  end
  
private
  
  def build_the_cells
    if params[:page_row][:cells_type] && !params[:page_row][:cells_type].blank?
      cells_type = params[:page_row][:cells_type]
      if cells_type == 'r4c1111'
        4.times do |pos|
          PageCell.create!( :page_row_id => @page_row.id, :cell_type => '1x4', :position => pos )
        end
      elsif cells_type == 'r3c111'
        3.times do |pos|
          PageCell.create!( :page_row_id => @page_row.id, :cell_type => '1x3', :position => pos )
        end
      elsif cells_type == 'r2c11'
        2.times do |pos|
          PageCell.create!( :page_row_id => @page_row.id, :cell_type => '1x2', :position => pos )
        end
      elsif cells_type == 'r4c112'
        2.times do |pos|
          PageCell.create!( :page_row_id => @page_row.id, :cell_type => '1x4', :position => pos )
        end
        PageCell.create!( :page_row_id => @page_row.id, :cell_type => '2x4', :position => 3 )
      elsif cells_type == 'r4c13'
        PageCell.create!( :page_row_id => @page_row.id, :cell_type => '1x4', :position => 1 )
        PageCell.create!( :page_row_id => @page_row.id, :cell_type => '3x4', :position => 2 )
      elsif cells_type == 'r3c12'
        PageCell.create!( :page_row_id => @page_row.id, :cell_type => '1x3', :position => 1 )
        PageCell.create!( :page_row_id => @page_row.id, :cell_type => '2x3', :position => 2 )
      else
        PageCell.create!( :page_row_id => @page_row.id, :cell_type => '1x1', :position => 1 )
      end
    end
  end
  
end