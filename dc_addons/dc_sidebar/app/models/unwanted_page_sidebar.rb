# encoding: utf-8
class UnwantedPageSidebar < ActiveRecord::Base
  
  # =====> A T T R I B U T E S <======================================================== #
  attr_accessible   :page_id, :sidebar_id
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  belongs_to :page,     :class_name => "Page",      :foreign_key => "page_id"
  belongs_to :sidebar,  :class_name => "Sidebar",   :foreign_key => "sidebar_id"
  
end
