# encoding: utf-8
class CarteEntryVariant < ActiveRecord::Base
  # A Menu - Entry / Dish / Drink / Tip
  
  # =====> A T T R I B U T E S <======================================================== #
  attr_accessible   :position,  :variant_price,   :variant_unit,  :variant_value,   :carte_entry_id
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  belongs_to :carte_entry, :class_name => "CarteEntry", :foreign_key => "carte_entry_id"
  
end
