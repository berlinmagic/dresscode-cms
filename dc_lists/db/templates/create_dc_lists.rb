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
    
    create_table :taggings do |t|
      t.references  :target, :polymorphic => true
      t.references  :tag
      t.timestamps
    end
    add_index :taggings, [:target_type, :target_id]
    
    
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
    
    create_table :categorizes do |t|
      t.references  :target, :polymorphic => true
      t.references  :category
      t.integer     :category_position
      t.integer     :target_position
      t.timestamps
    end
    add_index :categorizes, [:target_type, :target_id]
    
    
    create_table :values do |t|
      t.string      :name
      t.text        :content
      t.string      :param_value
      t.string      :style
      t.integer     :position
      t.references  :value_list
      t.timestamps
    end
    add_index :values, :value_list_id
    
    create_table :value_lists do |t|
      t.string      :name
      t.text        :description
      t.string      :param_name
      t.string      :style
      t.string      :type
      t.boolean     :system_stuff,          :default => false
      t.timestamps
    end
    add_index :value_lists, :name,     :unique => true
    
    
    
  end

  def self.down
    remove_index  :tags,            :name
    remove_index  :tags,            :slug
    remove_index  :categories,      :name
    remove_index  :categories,      :slug
    remove_index  :categorizes,     [:target_type, :target_id]
    remove_index  :values,          :value_list_id
    remove_index  :value_lists,     :name
    drop_table    :tags
    drop_table    :taggings
    drop_table    :categories
    drop_table    :categorizes
    drop_table    :value_lists
    drop_table    :values
  end
  
  
end