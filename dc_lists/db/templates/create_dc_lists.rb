class CreateDcLists < ActiveRecord::Migration
  
  def self.up
    
    create_table :tags do |t|
      t.string      :name
      t.string      :slug
      t.string      :firstletter
      t.timestamps
    end
    add_index :tags, :name,     :unique => true
    add_index :tags, :slug,     :unique => true
    add_index :tags, :firstletter
    
    
    create_table :taggings do |t|
      t.references  :target, :polymorphic => true
      t.references  :tag
      t.timestamps
    end
    add_index :taggings, [:target_type, :target_id]
    add_index :taggings, :tag
    
    
    
    create_table :categories do |t|
      t.string      :name
      t.string      :slug
      t.text        :description
      t.string      :style
      t.string      :type
      t.string      :firstletter
      t.timestamps
    end
    add_index :categories, :name,     :unique => true
    add_index :categories, :slug,     :unique => true
    add_index :categories, :firstletter
    
    
    create_table :categorizes do |t|
      t.references  :target, :polymorphic => true
      t.references  :category
      t.integer     :category_position
      t.integer     :target_position
      t.timestamps
    end
    add_index :categorizes, [:target_type, :target_id]
    add_index :categorizes, :category

    
    
  end

  def self.down
    remove_index  :tags,            :name
    remove_index  :tags,            :slug
    remove_index  :tags,            :firstletter
    remove_index  :taggings,        [:target_type, :target_id]
    remove_index  :taggings,        :tag
    remove_index  :categories,      :name
    remove_index  :categories,      :slug
    remove_index  :categories,      :firstletter
    remove_index  :categorizes,     [:target_type, :target_id]
    remove_index  :categorizes,     :category
    drop_table    :tags
    drop_table    :taggings
    drop_table    :categories
    drop_table    :categorizes
  end
  
  
end