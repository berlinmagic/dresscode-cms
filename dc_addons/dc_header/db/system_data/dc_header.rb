# encoding: utf-8
# ick hätt´s jern in utf, dankeschön. ähh .. müßte klappen # => litle joke, to force utf-8 encoding
#
#	DcHeader - Seed

	# puts("DcHeader seed")
	
	# Model.create!( :name => 'Name' )
  puts("DcHeader create header_pic")
  head_pic_one = DataFile.create!(
    
                        :name => "Dresscode Header",
                        :original_name => "dresscode_header.jpg",
                        :file_uid => "2012/01/28/23_40_42_20_dresscode_header.jpg", 
                        :file_name => "dcfile_2812012.jpg", 
                        :file_mime_type => "image/jpeg",
                        :file_ext => "jpg",
                        :file_size => "66467",
                        :image => true
    
  )
  
  puts("DcHeader create header")
  header_one = Header.create!(
                        
                        :name => "Default-Header",
                        :system_stuff => true,
                        :header_type => 'fader',
                        :width => 1200,
                        :height => 300,
                        :bg_color_one => '001f46',
                        :bg_color_two => '003366',
                        
                        
  )
  
  puts("DcHeader add pic to header")
  
  header_one.data_files << head_pic_one
  
  puts("DcHeader finished")



