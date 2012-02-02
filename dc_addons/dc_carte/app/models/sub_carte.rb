# encoding: utf-8
class SubCarte < ActiveRecord::Base
  # A SubMenu for Dishes / Drinks / etc
  
  # =====> A T T R I B U T E S <======================================================== #
  attr_accessible   :name,  :description,   :position,  :carte_type,  :aktiv,   :aktiv_from,  :aktiv_to,  :carte_id
  
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  belongs_to :carte, :class_name => "Carte", :foreign_key => "carte_id"
  
  has_many :carte_sets, :as => :target
  has_many :carte_entries, :through => :carte_sets, :as => :target, :uniq => true
  
  
end
