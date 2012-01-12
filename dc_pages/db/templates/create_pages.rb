class CreatePages < ActiveRecord::Migration
  
  def self.up
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
      
      t.boolean       :breadcrumps,     :default => true       # => Breadcrumps auf der Seite anzeigen ? 
      
      t.integer       :position                                 # => Sortierung
      t.integer       :site_level                                    # => Level der Seite
      
      t.integer       :parent_site_id                           # => Über- / Eltern-Seite
      t.integer       :main_site_id                            # => oberste Über- / Eltern-Seite
      
      t.integer       :author_id                                 # => Wer hat die Seite erstellt
      t.integer       :last_author_id                            # => Wer hat die Seite zuletzt geändert
      
      
      t.text          :text_content               # => Uebergangsloesung fuer Inhalt
      
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
    
    
    
  end

  def self.down
    drop_table :pages
  end
  
  
end