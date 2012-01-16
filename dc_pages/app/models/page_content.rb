# encoding: utf-8
class PageContent < ActiveRecord::Base
  
  belongs_to :page_cell, :class_name => "PageCell", :foreign_key => "page_cell_id"
  
end
