class CreateDcCarte < ActiveRecord::Migration
  
  def up
    
    create_table(:cartes) do |t|
      t.string      :name
      t.text        :description
      t.string      :carte_type                                                     # => dish's / drink's / both
      t.boolean     :aktiv,                             :default => true
      t.timestamps
    end
    add_index :cartes, :name
    
    create_table(:sub_cartes) do |t|
      t.string      :name
      t.text        :description
      t.integer     :position
      t.string      :carte_type                                                     # => dish's / drink's / both
      t.boolean     :aktiv,                             :default => true            # => depreacated !
      t.string      :view_type                                                      # => aktiv / time_based / inaktiv
      t.datetime    :aktiv_from
      t.datetime    :aktiv_to
      t.references  :carte
      t.timestamps
    end
    add_index :sub_cartes, :name
    add_index :sub_cartes, :carte_id
    
    create_table(:carte_sets) do |t|
      t.integer     :position
      t.references  :target,                            :polymorphic => true
      t.references  :carte_entry
      t.timestamps
    end
    add_index :carte_sets, [:target_type, :target_id]
    add_index :carte_sets, :carte_entry_id
    
    create_table(:carte_entries) do |t|
      t.string      :headline
      t.string      :sub_head
      t.text        :description
      t.integer     :position
      t.string      :entry_type                                                     # => dish / drink / headline / tip
      t.boolean     :use_ilike
      t.decimal     :master_price
      t.timestamps
    end
    add_index :carte_entries, :entry_type
    
    create_table(:carte_entry_variants) do |t|
      t.references  :carte_entry
      t.integer     :position
      t.decimal     :variant_price
      t.string      :variant_unit
      t.string      :variant_value
      t.timestamps
    end
    add_index :carte_entry_variants, :carte_entry_id
    
    
    create_table(:carte_substances) do |t|
      t.integer     :number
      t.string      :name
      t.text        :description
      t.timestamps
    end
    add_index :carte_substances, :number
    
    
    create_table :carte_entries_carte_substances, :id => false do |t|
      t.references  :carte_entry
      t.references  :carte_substance
      t.timestamps
    end
    
  end

  def down
    drop_table :cartes
    drop_table :sub_cartes
    drop_table :carte_sets
    drop_table :carte_entries
    drop_table :carte_entry_variants
    drop_table :carte_substances
    drop_table :carte_entries_carte_substances
  end
  
end