# encoding: utf-8
Page.class_eval do

  # =====> Sidebar - A S S O Z I A T I O N S <======================================================== #
  has_many :wanted_page_sidebars, :class_name => "WantedPageSidebar", :dependent => :destroy
  has_many :on_sidebars, :through => :wanted_page_sidebars, :source => :on_sidebar
  
  has_many :unwanted_page_sidebars, :class_name => "UnwantedPageSidebar", :dependent => :destroy
  has_many :off_sidebars, :through => :unwanted_page_sidebars, :source => :off_sidebar
  
end