class Twidget < ActiveRecord::Base
  
  # =====> C O N S T A N T S <======================================================== #
  COUNT = %w[multi one]
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  has_many :tcontents, :class_name => "Tcontent"
  
  
  # =====> S C O P E S <======================================================== #
  default_scope :order => "name ASC"
  
  
  # =====> A T T R I B U T E S <======================================================== #
  attr_accessible :name, :description, :widget_count, :widget_layout
  
  
  # =====> V A L I D A T I O N <======================================================== #
  validates :name, :widget_count, :widget_layout, :presence => true
  validates :name, :uniqueness => true
  
  
end
