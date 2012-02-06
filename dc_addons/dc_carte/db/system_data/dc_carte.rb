# encoding: utf-8
# 
# 
# 
puts 'INFO: create Carte-Page'
carte_page = Page.create!     :name => 'Speisekarte',
                              :page_type => 'module', # => no editable content
                              :system_page => true,
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


if !!defined?DcSidebar
  
  carte_sidebar = Sidebar.create!   :name => 'carte',
                                    :headline => 'Speisekarte',
                                    :content_type => 'module',
                                    :system_stuff => true,
                                    :view_type => 'aktiv',
                                    :multi_site => false
  
  carte_page.on_sidebars << carte_sidebar
  
end


meal_carte = Carte.create!      :name => 'Speisekarte',
                                :description => 'Lassen Sie sich verwöhnen, von unseren culinarischen Köstlichkeiten.',
                                :carte_type => "dishes",
                                :aktiv => true

meal_carte_soup = SubCarte.create!      :name => 'Suppen',
                                        :description => '..',
                                        :position => 0,
                                        :carte_type => meal_carte.carte_type,
                                        :view_type => 'aktiv'

soup_one = CarteEntry.create!       :headline => "Gecremtes Tomatensüppchen",
                                    :sub_head => "an Basilikumblatt und Crema Balsamico",
                                    :description => "",
                                    :position => 0,
                                    :entry_type => 'dish',
                                    :use_ilike => true,
                                    :master_price => 4.9

soup_two = CarteEntry.create!       :headline => "Ingwer - Karottensuppe",
                                    :sub_head => "an Gartenkräutern",
                                    :description => "",
                                    :position => 1,
                                    :entry_type => 'dish',
                                    :use_ilike => true,
                                    :master_price => 4.9

soup_three = CarteEntry.create!     :headline => "Kürbiscremesuppe mit Croutons",
                                    :sub_head => "und Steirischem Kürbiskernöl",
                                    :description => "",
                                    :position => 2,
                                    :entry_type => 'dish',
                                    :use_ilike => true,
                                    :master_price => 4.9


meal_carte.sub_cartes << meal_carte_soup

meal_carte_soup.carte_entries << soup_one
meal_carte_soup.carte_entries << soup_two
meal_carte_soup.carte_entries << soup_three


