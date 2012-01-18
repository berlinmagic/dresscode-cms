class Raster < ActiveRecord::Base
  
  # =====> C O N S T A N T S <======================================================== #
  RASTER_TYPES = %w[fixed float free]
  
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  has_many :tlayouts
  
  
  # =====> S C O P E S <======================================================== #
  default_scope :order => "name ASC"
  
  
  # =====> A T T R I B U T E S <======================================================== #
  attr_accessible :name, :description, :columns, :column_width, :gutter_width, :content_width, :full_width, :raster_type
  
  
  # =====> V A L I D A T I O N <======================================================== #
  validates :name, :columns, :content_width, :raster_type, :presence => true
  validates :name, :uniqueness => true
  
  
end
