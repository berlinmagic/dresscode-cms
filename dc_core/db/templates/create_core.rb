# encoding: utf-8
class CreateCore < ActiveRecord::Migration
  def up
    
    create_table :configurations, :force => true do |t|
      t.string        :name
      t.string        :type,       :limit => 50
      t.timestamps
    end
    add_index :configurations, [:name, :type], :name => "index_configurations_on_name_and_type"
    
    
    create_table :preferences,    :force => true do |t|
      t.string        :name,              :limit => 100, :null => false
      t.integer       :owner_id,          :limit => 30,  :null => false
      t.string        :owner_type,        :limit => 50,  :null => false
      t.integer       :group_id
      t.string        :group_type,        :limit => 50
      t.text          :value      # => ,  :limit => 255   ???
      t.timestamps
    end
    add_index :preferences, [:owner_id, :owner_type, :name, :group_id, :group_type], :name => "ix_prefs_on_owner_attr_pref", :unique => true
    
    
    create_table :data_files,     :force => true do |t|
      t.string        :name                                       # => image/file - name  (url-safe)
      t.text          :description                                # => description if needed / wanted
      t.text          :alt                                        # => alt-atribute
      
      t.string        :filename                                   # => original file-name
      t.string        :filetype                                   # => file-type ? .. bsp: jpg
      t.string        :mimetype                                   # => mime_type ?    bsp: image/jpg
      
      t.string        :file_uid                                   # => Dragonfly
      t.boolean       :image,             :default => false       # => bild ?
      
      t.integer       :author                                     # => file-autor / uploader
      t.boolean       :protected_stuff,   :default => false       # => file protected only visible for ?
      t.references    :group                                      # => this group can see protected file
      t.datetime      :deleted_at                                 # => file deleted at (in trash)
      t.boolean       :system_stuff,      :default => false       # => system-file? ... user can´t delete
      t.timestamps
    end
    add_index :data_files, :name, :unique => true
    add_index :data_files, :system_stuff
    
    
    create_table :attachments, :force => true do |t|
      t.references  :target, :polymorphic => true
      t.references  :data_file
      t.integer     :position
      t.timestamps
    end
    add_index :attachments, :target_type
    add_index :attachments, :target_id
    add_index :attachments, :data_file
    add_index :attachments, :position
    
  end

  def self.down
    drop_table :configurations
    drop_table :preferences
    drop_table :data_files
    drop_table :attachments
  end
end