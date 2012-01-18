class CreateDcThemesDynamicStyles < ActiveRecord::Migration
  
  def self.up
    
    create_table :class_assignments, :force => true do |t|
      t.integer  :style_class_id
      t.string   :target_type
      t.integer  :target_id
      t.timestamps
    end

    add_index :class_assignments, ["style_class_id"], :name => "index_class_assignments_on_style_class_id"
    add_index :class_assignments, ["target_id"], :name => "index_class_assignments_on_target_id"
    add_index :class_assignments, ["target_type"], :name => "index_class_assignments_on_target_type"
    
    create_table :style_classes, :force => true do |t|
      t.string   :name
      t.text     :description
      t.string   :the_group
      t.text     :the_style
      t.timestamps
    end

    add_index :style_classes, ["name"], :name => "index_style_classes_on_name"
    
    create_table :styles, :force => true do |t|
      t.string   :name
      t.text     :the_style
      t.string   :target_type
      t.integer  :target_id
      t.timestamps
    end

    add_index :styles, ["name"], :name => "index_styles_on_name"
    add_index :styles, ["target_id"], :name => "index_styles_on_target_id"
    add_index :styles, ["target_type"], :name => "index_styles_on_target_type"
    
  end

  def self.down
    drop_table :class_assignments
    drop_table :style_classes
    drop_table :styles
  end
  
  
end