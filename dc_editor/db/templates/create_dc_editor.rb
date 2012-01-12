class CreateDcEditor < ActiveRecord::Migration
  def self.up
    create_table :dc_editor_images, :force => true do |t|
    t.string   :image_file_name
    t.string   :image_content_type
    t.integer  :image_file_size
    t.datetime :image_updated_at
    t.timestamps
  end
  end

  def self.down
    drop_table :dc_editor_images
  end
end