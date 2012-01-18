class Style < ActiveRecord::Base
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  belongs_to :target, :polymorphic => true
  
  # =====> S C O P E S <======================================================== #
  default_scope :order => "name ASC"
  
  
  # =====> A T T R I B U T E S <======================================================== #
  attr_accessible :name, :the_style, :target_type, :target_id
  
  
  # =====> V A L I D A T I O N <======================================================== #
  validates :name, :the_style, :presence => true
  
  
end
