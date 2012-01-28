# encoding: utf-8
# 
# 
puts 'INFO: create Contact-Page'
contact_page = Page.create!   :name => 'Kontakt',
                              :site_type => 'system', 
                              :system_name => 'contact',
                              :use_title => true,
                              :title => 'dresscode Kontakt-Seite',
                              :headline_type => 'headline',
                              :headline => 'dresscode Kontakt-Seite',
                              :in_sec_nav => true, 
                              :in_system_nav => false, 
                              :in_main_nav => true, 
                              :meta_description => 'dresscode CMS - Standard Start-Seite', 
                              :meta_keywords => 'dresscode CMS, orangenwerk',
                              :tlayout_id => 1,
                              :text_content => ''

puts 'INFO: create Contact-Page layout and content'

contact_row_one = PageRow.create!     :page_id => contact_page.id, :position => 1
contact_cell_one = PageCell.create!    :page_row_id => contact_row_one.id, :cell_type => '1x1', :position => 1
PageContent.create! :page_cell_id => contact_cell_one.id, :text_content => '<h1>Beispiel Kontakt-Seite</h1><br/><p>Laden Sie den editor um diese zu bearbeiten.</p><br/>'

contact_row_two = PageRow.create!     :page_id => contact_page.id, :position => 1
contact_cell_two = PageCell.create!    :page_row_id => contact_row_two.id, :cell_type => '1x1', :position => 1
PageContent.create! :page_cell_id => contact_cell_two.id, :content_type => 'contactform'

contact_row_three = PageRow.create!     :page_id => contact_page.id, :position => 1
contact_cell_three = PageCell.create!    :page_row_id => contact_row_three.id, :cell_type => '1x1', :position => 1
PageContent.create! :page_cell_id => contact_cell_three.id, :text_content => '<p>Beispiel Kontakt-Seite .. Laden Sie den editor um diese zu bearbeiten.</p><br/>'

puts 'INFO: finished Contact-Page!'


