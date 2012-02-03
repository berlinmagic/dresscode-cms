class CreateDcSidebar < ActiveRecord::Migration
  
  def up
    
    create_table( :sidebars ) do |t|
      t.string        :name
      t.string        :headline
      t.text          :text_content
      
      t.string        :content_type                                                   # => text / module / etc.
      t.string        :sidebar_type                                                   # => for different looks and styling
      t.string        :view_type                                                      # => aktiv / date_based / inaktiv
      
      t.datetime      :view_from
      t.datetime      :view_till
      
      t.boolean       :system_stuff,              :default => false                   # => system-box? ... user can´t delete
      t.boolean       :multi_site,                :default => false                   # => show box on all sites (except unwanted_page_sidebars)
      
      t.references    :module,                    :polymorphic => true
      
      t.datetime      :deleted_at                                                     # => box deleted at (in trash)
      
      t.timestamps
    end
    add_index :sidebars, [:module_type, :module_id]
    
    
    change_table :pages do |t|
      t.string        :use_sidebar,               :default => 'left'                  # => sidebar:  left / right / none
    end
    Page.update_all ["use_sidebar = ?", 'left']
    
    
    create_table( :wanted_page_sidebars ) do |t|
      t.integer       :position
      t.string        :side
      t.references    :page
      t.references    :sidebar
      t.timestamps
    end
    
    create_table( :unwanted_page_sidebars ) do |t|
      t.references    :page
      t.references    :sidebar
      t.timestamps
    end
    
    
  end

  def down
    drop_table :sidebars
    remove_column :pages, :use_sidebar
  end
  
  
end