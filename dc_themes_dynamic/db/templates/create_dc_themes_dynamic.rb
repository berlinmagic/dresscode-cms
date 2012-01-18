class CreateDcThemesDynamic < ActiveRecord::Migration
  def self.up
    
    create_table :tag_lists do |t|
      t.string :name
      t.string :tag
      t.string :tag_counter,      :default => "multi"
      t.text :description
      t.string :tag_type
      t.boolean :system_stuff
      t.timestamps
    end
    add_index :tag_lists, :name
    
    create_table :tag_assignments do |t|
      t.integer :the_tag
      t.integer :the_data
      t.boolean :needed,              :default => false
      t.boolean :has_value,           :default => true
      t.timestamps
    end
    add_index :tag_assignments, :the_tag
    add_index :tag_assignments, :the_data
    
    
    create_table :rasters do |t|
      t.string :name
      t.text :description
      t.integer :columns
      t.integer :column_width
      t.integer :gutter_width
      t.integer :content_width
      t.integer :full_width
      t.string :raster_type
      t.timestamps
    end
    
    
    create_table :tlayouts do |t|
      t.string :name
      t.text :description
      t.references :raster
      t.timestamps
    end
    add_index :tlayouts, :name
    add_index :tlayouts, :raster_id
    
    
    create_table :telements do |t|
      t.string :name
      t.string :cms_ident
      t.integer :position
      t.integer :columns
      t.string :element_type
      t.integer :element_level
      
      t.integer :this_width
      t.string :w_unit
      t.boolean :use_raster
      
      
      t.integer :this_layout
      t.references :tlayout
      t.references :telement
      t.references :tag_list
      t.timestamps
    end
    add_index :telements, :cms_ident
    add_index :telements, :tlayout_id
    add_index :telements, :telement_id
    add_index :telements, :this_layout
    add_index :telements, :tag_list_id
    
    
    create_table :tcontents do |t|
      t.string :name
      t.string :cms_ident
      t.integer :position
      t.integer :columns
      t.text :text_content,                     :default => '<p><strong>Text</strong> (<em>editierbar!</em>)</p>'
      t.integer :this_width
      t.string :w_unit
      
      t.integer :this_layout
      t.references :twidget
      t.references :tlayout
      t.references :telement
      # => t.references :page
      t.timestamps
    end
    add_index :tcontents, :cms_ident
    add_index :tcontents, :tlayout_id
    add_index :tcontents, :telement_id
    add_index :tcontents, :this_layout
    add_index :tcontents, :twidget_id
    # => add_index :tcontents, :page_id
    
    
    create_table :twidgets do |t|
      t.string    :name
      t.text      :description
      t.string    :widget_count
      t.string    :widget_layout
      t.integer   :min_width
      t.integer   :max_width
      t.timestamps
    end
    
    
    
  end

  def self.down
    drop_table :tag_lists
    drop_table :tag_assignments
    drop_table :rasters
    drop_table :tlayouts
    drop_table :telements
    drop_table :tcontents
    drop_table :twidgets
  end
end