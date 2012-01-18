class StyleClass < ActiveRecord::Base
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  has_many :class_assignments, :dependent => :destroy
  
  
  # =====> S C O P E S <======================================================== #
  default_scope :order => "name ASC"
  
  
  # =====> A T T R I B U T E S <======================================================== #
  attr_accessible :name, :description, :the_group, :the_style
  
  
  # =====> V A L I D A T I O N <======================================================== #
  validates :name, :description, :the_style, :presence => true
  validates :name, :uniqueness => true
  
  
end
