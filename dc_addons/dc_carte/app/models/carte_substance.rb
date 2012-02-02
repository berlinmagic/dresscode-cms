# encoding: utf-8
class CarteSubstance < ActiveRecord::Base
  # For special incredients in meals and drinks
  
  # =====> A T T R I B U T E S <======================================================== #
  attr_accessible   :number,  :name,  :description
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  has_and_belongs_to_many :carte_entries, :join_table => "carte_entries_carte_substances"
  
end
