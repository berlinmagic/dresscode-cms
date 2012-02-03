# encoding: utf-8
Page.class_eval do

  # =====> Sidebar - A S S O Z I A T I O N S <======================================================== #
  has_many :wanted_page_sidebars, :class_name => "WantedPageSidebar", :foreign_key => "page_id", :dependent => :destroy
  has_many :on_sidebars, :through => :wanted_page_sidebars, :class_name => "Page"
  
  has_many :unwanted_page_sidebars, :class_name => "UnwantedPageSidebar", :foreign_key => "page_id", :dependent => :destroy
  has_many :off_sidebars, :through => :unwanted_page_sidebars, :class_name => "Page"
  
end