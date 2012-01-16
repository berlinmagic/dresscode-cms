# encoding: utf-8
class PageCell < ActiveRecord::Base
  
  belongs_to :page_row, :class_name => "PageRow", :foreign_key => "page_row_id"
  
  has_many :page_contents, :foreign_key => "page_cell_id", :dependent => :destroy
  
  accepts_nested_attributes_for   :page_contents,  :allow_destroy => true
  
end
