# encoding: utf-8
class CarteEntry < ActiveRecord::Base
  # A Menu - Entry / Dish / Drink / Tip
  
  # =====> C O N S T A N T S <======================================================== #
  ENTRY_TYPES = %w(dish drink tip headline)
  
  # =====> A T T R I B U T E S <======================================================== #
  attr_accessible   :headline,  :sub_head,  :description,   :position,  :entry_type,  :use_ilike,   :master_price
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  has_many :carte_sets, :class_name => "CarteSet", :foreign_key => "carte_entry_id"
  
  has_many :carte_entry_variants, :class_name => "CarteEntryVariant", :foreign_key => "carte_entry_id", :dependent => :destroy
  
  has_many :attachments, :class_name => "Attachment", :as => :target
  has_many :data_files, :through => :attachments, :source => :attachments
  
  has_and_belongs_to_many :carte_substances, :join_table => "carte_entries_carte_substances"
  
end
