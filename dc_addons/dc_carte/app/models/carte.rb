# encoding: utf-8
class Carte < ActiveRecord::Base
  # A Menu for SubCartes / Dishes / Drinks / etc
  
  # =====> C O N S T A N T S <======================================================== #
  CARTE_TYPES = %w(dishes drinks both)
  
  
  # =====> A T T R I B U T E S <======================================================== #
  attr_accessible       :name,    :description,     :carte_type,    :aktiv
  
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  has_many :sub_cartes, :class_name => "SubCarte", :foreign_key => "carte_id"
  
  has_many :carte_sets, :as => :target
  has_many :carte_entries, :through => :carte_sets, :as => :target, :uniq => true
  
  
  
  validates_presence_of       :name
  validates_uniqueness_of     :name, :slug
  
  
  before_validation :generate_safe_slug
  
  
  def generate_safe_slug
    self.slug = self.name.to_url if self.name
  end
  
end
