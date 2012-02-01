class CreateDcMercury < ActiveRecord::Migration
  
  def up
    
	  create_table :dc_mercury_images do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.timestamps
    end
    
  end

  def down
	  drop_table :dc_mercury_images
  end
  
  
end