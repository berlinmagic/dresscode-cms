class CreatePages < ActiveRecord::Migration
  
  def up
    create_table :pages do |t|
      t.string        :name                                     # => Name der Seite & Link-name
      
      t.boolean       :use_title,       :default => false       # => abweichenden Titel verwenden (= nicht Namen) ?
      t.text          :title                                    # => Browser-Titel
      
      t.string        :headline_type,   :default => 'name'      # => name | headline | none
      t.text          :headline                                 # => Überschrift der Seite
      
      t.string        :slug                                     # => Domain der Seite (zB: '/kontakt' oder '/')
      t.string        :full_slug                                # => Domain der Seite (zB: '/ueber_uns/kontakt')
      t.string        :std_slug                                 # => StandardDomain (Falls zB: '/start' für '/')
      
      t.string        :site_type,       :default => 'page'      # => page | system | modul | ...
      t.string        :type_param,      :default => 'default'   # => default | system_only | protected | ...
      
      t.string        :system_name                              # => Um System-Seiten finden zu können
      
      t.string        :modul_type                               # => Um System-Seiten finden zu können
      t.string        :modul_id                                 # => Um System-Seiten finden zu können
      
      t.text          :meta_description                         # => Google-Beschreibung
      t.text          :meta_keywords                            # => Google-Keywords
      
      t.boolean       :fowarding_site,   :default => false       # => Seite ist eine Weiterleitung
      t.string        :external_link,   :default => ''          # => Url der weiterleitung wenn Aktiv
      
      t.references    :tlayout                                  # => wird noch nicht verwendet
      
      t.boolean       :in_main_nav,     :default => true       # => Seite im Header Anzeigen ?
      t.boolean       :in_system_nav,   :default => false        # => Seite im Haupt-/Subnavigation Anzeigen ?
      t.boolean       :in_sec_nav,      :default => true        # => Seite im Footer Anzeigen ?
      
      t.boolean       :protected_stuff, :default => false       # => Seite nur für 'xx' - Nutzer sichtbar
      t.references    :group                                   # => Rechte-Modul .. Gruppe / Rang aufwärts
      
      t.boolean       :spread_site,       :default => false       # => Seite nur Verteiler
      
      t.datetime      :deleted_at                               # => Wann gelöscht
      t.boolean       :is_draft,         :default => false      # => Seite ist im Entwurf-Stadium (evtl. nur für den Ersteller sichtbar ?)
      
      t.boolean       :breadcrumps,       :default => true       # => Breadcrumps auf der Seite anzeigen ? 
      
      t.integer       :position                                 # => Sortierung
      t.integer       :site_level                                    # => Level der Seite
      
      t.integer       :parent_site_id                           # => Über- / Eltern-Seite
      t.integer       :main_site_id                            # => oberste Über- / Eltern-Seite
      
      t.integer       :author_id                                 # => Wer hat die Seite erstellt
      t.integer       :last_author_id                            # => Wer hat die Seite zuletzt geändert
      
      
      t.text          :text_content                             # => Uebergangsloesung fuer Inhalt
      
      t.timestamps
    end
    add_index :pages, :name,           :unique => true
    add_index :pages, :slug,           :unique => true
    add_index :pages, :std_slug,       :unique => true
    add_index :pages, :full_slug,      :unique => true
    add_index :pages, :deleted_at
    add_index :pages, :position
    add_index :pages, :parent_site_id
    add_index :pages, :main_site_id
    add_index :pages, :tlayout_id
    
    
    create_table :page_rows do |t|
      t.string        :dc_uid,              :default => ""
      t.string        :name                                     # => for anchor
      t.integer       :position                                 # => Sortierung
      
      t.references    :page
      t.timestamps
    end
    add_index :page_rows, :dc_uid, :unique => true
    add_index :page_rows, :page_id
    add_index :page_rows, :position
    
    
    create_table :page_cells do |t|
      t.string        :dc_uid,              :default => ""
      t.integer       :position                                 # => Sortierung
      t.string        :cell_type                                # => Cell Type
      
      t.references    :page_row
      t.timestamps
    end
    add_index :page_cells, :dc_uid, :unique => true
    add_index :page_cells, :page_row_id
    add_index :page_cells, :position
    
    
    create_table :page_contents do |t|
      t.string        :dc_uid,              :default => ""
      t.integer       :position                                 # => Sortierung
      
      t.string        :content_type,        :default => "text"  # => which Content
      
      t.text          :text_content
      
      t.references    :target, :polymorphic => true             # => Modul - Content
      
      t.references    :page_cell
      t.timestamps
    end
    add_index :page_contents, :dc_uid, :unique => true
    add_index :page_contents, [:target_type, :target_id]
    add_index :page_contents, :page_cell_id
    add_index :page_contents, :position
    
  end

  def down
    drop_table :pages
    drop_table :page_rows
    drop_table :page_cells
    drop_table :page_contents
  end
  
  
end