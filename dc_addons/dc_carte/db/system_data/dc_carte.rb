# encoding: utf-8
# 
# 
# 
puts 'INFO: create Carte-Page'
carte_page = Page.create!     :name => 'Speisekarte',
                              :site_type => 'system', 
                              :system_name => 'carte',
                              :use_title => true,
                              :title => 'dresscode Speisekarte',
                              :headline_type => 'headline',
                              :headline => 'dresscode Speisekarte',
                              :in_sec_nav => true, 
                              :in_system_nav => false, 
                              :in_main_nav => true, 
                              :meta_description => 'dresscode CMS - Standard Speisekarte', 
                              :meta_keywords => 'dresscode CMS, orangenwerk',
                              :tlayout_id => 1

puts 'INFO: create Contact-Page layout and content'

carte_row_one = PageRow.create!     :page_id => carte_page.id, :position => 1
carte_cell_one = PageCell.create!    :page_row_id => carte_row_one.id, :cell_type => '1x1', :position => 1
PageContent.create! :page_cell_id => carte_cell_one.id, :content_type => 'carte'


puts 'INFO: finished Carte-Page!'



