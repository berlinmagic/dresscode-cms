# encoding: utf-8
class CreateCore < ActiveRecord::Migration
  def self.up
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
      t.string        :name                                       # => Bild / Datei - Name  (wird url-sicher gemacht)
      t.string        :oname                                      # => original DateiName
      t.text          :desc                                       # => beschreibung
      t.text          :alt                                        # => alt-text
      t.string        :file_uid                                   # => Dragonfly
      t.boolean       :image,             :default => false       # => bild ?
      t.string        :mime_type                                  # => datei - mime_type ?    bsp: image/jpg
      t.string        :file_type                                  # => datei - file_type ? .. bsp: jpg
      t.string        :typ                                        # => ..
      t.string        :modul                                      # => ..
      t.integer       :author                                     # => datei-autor
      t.boolean       :protected_stuff,   :default => false       # => datei protected only visible for ?
      t.references    :gruppe                                     # => this group can see protected dateien
      t.datetime      :deleted_at                                 # => datei deleted at (in trash)
      t.boolean       :system_stuff,      :default => false       # => system-datei? ... user can´t delete
      t.timestamps
    end
    
    create_table :attachments, :force => true do |t|
      t.references  :target, :polymorphic => true
      t.references  :data_file
      t.integer     :position
      t.timestamps
    end
    
  end

  def self.down
    drop_table :configurations
    drop_table :preferences
    drop_table :data_files
    drop_table :attachments
  end
end