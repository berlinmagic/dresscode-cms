# encoding: utf-8
# 
puts 'INFO: create Carte-Page'
carte_page = Page.create!     :name => 'unser Angebot',
                              :page_type => 'module', # => no editable content
                              :system_page => true,
                              :system_name => 'carte',
                              :use_title => true,
                              :title => 'unser Angebote',
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
  
  puts 'INFO: create Carte-Sidebar'
  carte_sidebar = Sidebar.create!   :name => 'carte',
                                    :headline => 'Speisekarte',
                                    :content_type => 'module',
                                    :system_stuff => true,
                                    :view_type => 'aktiv',
                                    :multi_site => false
  
  carte_page.on_sidebars << carte_sidebar
  
end

puts 'INFO: create Carte'

meal_carte = Carte.create!      :name => 'Speisekarte',
                                :description => 'Lassen Sie sich verwöhnen, von unseren culinarischen Köstlichkeiten.',
                                :carte_type => "dishes",
                                :position => 0,
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


meal_carte_vorspeise = SubCarte.create! :name => 'Vorspeisen',
                                        :description => '..',
                                        :position => 1,
                                        :carte_type => meal_carte.carte_type,
                                        :view_type => 'aktiv'

vorspeise_one = CarteEntry.create!      :headline => 'Auberginenkissen „Carollis“',
                                        :sub_head => "mundig gefüllt mit Ziegenkäse, dazu Bukett von Gartensalaten und Cherrytomate",
                                        :description => "",
                                        :position => 0,
                                        :entry_type => 'dish',
                                        :use_ilike => true,
                                        :master_price => 6.9

vorspeise_two = CarteEntry.create!      :headline => "Gebeizter - Lachs",
                                        :sub_head => "dazu Kartoffelrösti und Honig – Senfsauce",
                                        :description => "",
                                        :position => 1,
                                        :entry_type => 'dish',
                                        :use_ilike => true,
                                        :master_price => 8.5

vorspeise_three = CarteEntry.create!    :headline => "Bardierter Ziegenkäse aus dem Rohr",
                                        :sub_head => "Ziegenfrischkäse mariniert, eingeschlagen in Räucherlandschinken und Salatbukett",
                                        :description => "",
                                        :position => 2,
                                        :entry_type => 'dish',
                                        :use_ilike => true,
                                        :master_price => 7.5


meal_carte.sub_cartes << meal_carte_vorspeise

meal_carte_vorspeise.carte_entries << vorspeise_one
meal_carte_vorspeise.carte_entries << vorspeise_two
meal_carte_vorspeise.carte_entries << vorspeise_three


drinks_carte = Carte.create!              :name => 'Getränkekarte',
                                          :description => 'Lassen Sie sich verwöhnen, von unseren culinarischen Köstlichkeiten.',
                                          :position => 1,
                                          :carte_type => "drinks",
                                          :aktiv => true

drinks_carte_sub_one = SubCarte.create!   :name => 'Kaffee Spezialitäten',
                                          :description => '..',
                                          :position => 0,
                                          :carte_type => drinks_carte.carte_type,
                                          :view_type => 'aktiv'

drinks_sub_one_first = CarteEntry.create! :headline => 'Kaffee Creme',
                                          # => :sub_head => "",
                                          # => :description => "",
                                          :position => 0,
                                          :entry_type => 'drink',
                                          :use_ilike => true,
                                          :master_price => 1.9

drinks_sub_one_second = CarteEntry.create! :headline => 'Pott Kaffee',
                                          # => :sub_head => "",
                                          # => :description => "",
                                          :position => 1,
                                          :entry_type => 'drink',
                                          :use_ilike => true,
                                          :master_price => 2.5

drinks_sub_one_third = CarteEntry.create! :headline => 'Espresso',
                                          # => :sub_head => "",
                                          # => :description => "",
                                          :position => 2,
                                          :entry_type => 'drink',
                                          :use_ilike => true,
                                          :master_price => 1.8


drinks_carte.sub_cartes << drinks_carte_sub_one

drinks_carte_sub_one.carte_entries << drinks_sub_one_first
drinks_carte_sub_one.carte_entries << drinks_sub_one_second
drinks_carte_sub_one.carte_entries << drinks_sub_one_third


puts 'INFO: finished Carte!'


