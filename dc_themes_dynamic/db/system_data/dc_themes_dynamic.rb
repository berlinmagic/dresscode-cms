   



grids = Raster.create!([
  
    { :name => "12er Grid [10]", :columns => 12, :column_width => 70, :gutter_width => 10, 
      :content_width => 950, :full_width => 960, :raster_type => "fixed",
      :description => "Gridsystem mit 12 Spalten und einem Abstand von 10 Pixel." },
    
    { :name => "12er Grid [20]", :columns => 12, :column_width => 60, :gutter_width => 20, 
      :content_width => 940, :full_width => 960, :raster_type => "fixed",
      :description => "Gridsystem mit 12 Spalten und einem Abstand von 20 Pixel." },
    
    { :name => "12er Grid [30]", :columns => 12, :column_width => 50, :gutter_width => 30, 
      :content_width => 930, :full_width => 960, :raster_type => "fixed",
      :description => "Gridsystem mit 12 Spalten und einem Abstand von 30 Pixel." },
    
    { :name => "16er Grid [10]", :columns => 16, :column_width => 50, :gutter_width => 10, 
      :content_width => 950, :full_width => 960, :raster_type => "fixed",
      :description => "Gridsystem mit 16 Spalten und einem Abstand von 10 Pixel." },
    
    { :name => "16er Grid [20]", :columns => 16, :column_width => 40, :gutter_width => 20, 
      :content_width => 940, :full_width => 960, :raster_type => "fixed",
      :description => "Gridsystem mit 16 Spalten und einem Abstand von 20 Pixel." },
    
    { :name => "16er Grid [30]", :columns => 16, :column_width => 30, :gutter_width => 30, 
      :content_width => 930, :full_width => 960, :raster_type => "fixed",
      :description => "Gridsystem mit 16 Spalten und einem Abstand von 10 Pixel." },
    
    { :name => "24er Grid [10]", :columns => 24, :column_width => 30, :gutter_width => 10, 
      :content_width => 950, :full_width => 960, :raster_type => "fixed",
      :description => "Gridsystem mit 24 Spalten und einem Abstand von 10 Pixel." },
    
    { :name => "24er Grid [20]", :columns => 24, :column_width => 20, :gutter_width => 20, 
      :content_width => 940, :full_width => 960, :raster_type => "fixed",
      :description => "Gridsystem mit 24 Spalten und einem Abstand von 20 Pixel." },
    
    { :name => "48er Grid [10]", :columns => 48, :column_width => 10, :gutter_width => 10, 
      :content_width => 950, :full_width => 960, :raster_type => "fixed",
      :description => "Gridsystem mit 48 Spalten und einem Abstand von 10 Pixel." }
    
  ])
  
  
html_tags = TagList.create!([
      { :name => 'Container', :tag => 'div', :description => '', :tag_type => 'tag', :tag_counter => 'multi' },
      { :name => 'Sektion', :tag => 'section', :description => '', :tag_type => 'tag', :tag_counter => 'multi' },
      { :name => 'Header', :tag => 'header', :description => '', :tag_type => 'tag', :tag_counter => 'one' },
      { :name => 'Footer', :tag => 'footer', :description => '', :tag_type => 'tag', :tag_counter => 'one' },
      { :name => 'Artikel', :tag => 'article', :description => '', :tag_type => 'tag', :tag_counter => 'multi' }
  ])
  
template_widgets = Twidget.create!([
      { :name => 'Content', :description => 'Haupt-Inhalt', :widget_count => 'one', :widget_layout => 'content', 
        :min_width => 500, :max_width => 1400 },
      { :name => 'Nav-Main', :description => 'Haupt-Navigation', :widget_count => 'one', :widget_layout => 'nav_main', 
        :min_width => 150, :max_width => 1200 },
      { :name => 'Nav-System', :description => 'System-Navigation', :widget_count => 'one', :widget_layout => 'nav_system', 
        :min_width => 150, :max_width => 1200 },
      { :name => 'Sidebar', :description => 'Sidebar-Inhalt', :widget_count => 'one', :widget_layout => 'sidebar', 
        :min_width => 100, :max_width => 500 },
      { :name => 'Text', :description => 'Text-Inhalt', :widget_count => 'multi', :widget_layout => 'text', 
        :min_width => 100, :max_width => 1400 }
  ])

the_grid = Raster.where('name == ?', "12er Grid [20]").first

the_layout = Tlayout.create!( :name => 'Std 12er (20)', :raster_id => the_grid.id, :description => 'Standard-Layout' )

the_header = Telement.create!(  :element_type => 'box', :columns => 1, :tag_list_id => 1, 
                                :tlayout_id => the_layout.id, :position => 1 )

the_header_c = Telement.create!( :element_type => 'grid_row', :columns => 12, :tag_list_id => 1, 
                                 :telement_id => the_header.id, :position => 1 )

header_box1 = Telement.create!( :element_type => 'grid_cell', :columns => 3, :tag_list_id => 1, 
                                 :telement_id => the_header_c.id, :position => 1 )
header_box2 = Telement.create!( :element_type => 'grid_cell', :columns => 9, :tag_list_id => 1, 
                                 :telement_id => the_header_c.id, :position => 2 )


the_content = Telement.create!(  :element_type => 'box', :columns => 1, :tag_list_id => 1, 
                                :tlayout_id => the_layout.id, :position => 2 )

the_content_c = Telement.create!( :element_type => 'grid_row', :columns => 12, :tag_list_id => 1, 
                                 :telement_id => the_content.id, :position => 1 )

content_box1 = Telement.create!( :element_type => 'grid_cell', :columns => 3, :tag_list_id => 1, 
                                 :telement_id => the_content_c.id, :position => 1 )
content_box2 = Telement.create!( :element_type => 'grid_cell', :columns => 9, :tag_list_id => 1, 
                                 :telement_id => the_content_c.id, :position => 2 )

the_foota = Telement.create!(  :element_type => 'box', :columns => 1, :tag_list_id => 1, 
                                :tlayout_id => the_layout.id, :position => 3 )

the_foota_c = Telement.create!( :element_type => 'grid_row', :columns => 12, :tag_list_id => 1, 
                                 :telement_id => the_foota.id, :position => 1 )

foota_box1 = Telement.create!( :element_type => 'grid_cell', :columns => 3, :tag_list_id => 1, 
                                 :telement_id => the_foota_c.id, :position => 1 )
foota_box2 = Telement.create!( :element_type => 'grid_cell', :columns => 6, :tag_list_id => 1, 
                                 :telement_id => the_foota_c.id, :position => 2 )
foota_box3 = Telement.create!( :element_type => 'grid_cell', :columns => 3, :tag_list_id => 1, 
                                 :telement_id => the_foota_c.id, :position => 3 )


content_elemente = Tcontent.create!([
      { :twidget_id => 5, :telement_id => header_box1.id, :this_layout_id => 1 },
      { :twidget_id => 2, :telement_id => header_box2.id, :this_layout_id => 1 },
      
      { :twidget_id => 4, :telement_id => content_box1.id, :this_layout_id => 1 },
      { :twidget_id => 1, :telement_id => content_box2.id, :this_layout_id => 1 },
      
      { :twidget_id => 5, :telement_id => foota_box1.id, :this_layout_id => 1 },
      { :twidget_id => 3, :telement_id => foota_box2.id, :this_layout_id => 1 },
      { :twidget_id => 5, :telement_id => foota_box3.id, :this_layout_id => 1 }
  ])
