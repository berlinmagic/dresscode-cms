# encoding: utf-8
class Sidebar < ActiveRecord::Base
  
  CONTENT_TYPES  = %w(text module function)
  SIDEBAR_TYPES  = %w(standard)
  VIEW_TYPES     = %w(aktiv timebased inaktiv)
  
  
  # =====> A T T R I B U T E S <======================================================== #
  attr_accessible   :name, :headline, :text_content, :content_type, :sidebar_type, :view_type, :view_from, :view_till, :system_stuff, :multi_site, 
                    :module_type, :module_id, :deleted_at
  
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  belongs_to :module, :polymorphic => true
  
  has_many :wanted_page_sidebars, :class_name => "WantedPageSidebar", :dependent => :destroy
  has_many :on_pages, :through => :wanted_page_sidebars, :source => :on_page
  
  has_many :unwanted_page_sidebars, :class_name => "UnwantedPageSidebar", :dependent => :destroy
  has_many :off_pages, :through => :unwanted_page_sidebars, :source => :off_page
  
  has_many :attachments, :class_name => "Attachment", :as => :target
  has_many :data_files, :through => :attachments

  
end
