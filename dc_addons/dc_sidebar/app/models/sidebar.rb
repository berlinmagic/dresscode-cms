# encoding: utf-8
class Sidebar < ActiveRecord::Base
  # For special incredients in meals and drinks
  
  # =====> A T T R I B U T E S <======================================================== #
  attr_accessible   :name, :headline, :text_content, :content_type, :sidebar_type, :view_type, :view_from, :view_till, :system_stuff, :multi_site, 
                    :module_type, :module_id, :deleted_at
  
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  belongs_to :module, :polymorphic => true
  
  has_many :wanted_page_sidebars, :class_name => "WantedPageSidebar", :foreign_key => "sidebar_id", :dependent => :destroy
  has_many :on_pages, :through => :wanted_page_sidebars, :class_name => "Page"
  
  has_many :unwanted_page_sidebars, :class_name => "UnwantedPageSidebar", :foreign_key => "sidebar_id", :dependent => :destroy
  has_many :off_pages, :through => :unwanted_page_sidebars, :class_name => "Page"
  
  has_many :attachments, :class_name => "Attachment", :as => :target
  has_many :data_files, :through => :attachments

  
end
