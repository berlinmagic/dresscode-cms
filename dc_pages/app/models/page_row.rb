# encoding: utf-8
class PageRow < ActiveRecord::Base
  
  # PageRows are the top-level of the table-like Page Content
  
  belongs_to :page, :class_name => "Page", :foreign_key => "page_id"
  
  has_many :page_cells, :foreign_key => "page_row_id", :dependent => :destroy
  has_many :page_contents, :through => :page_cells
  
  accepts_nested_attributes_for   :page_cells,  :allow_destroy => true
  
  
end
