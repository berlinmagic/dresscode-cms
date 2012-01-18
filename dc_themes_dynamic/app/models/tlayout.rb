class Tlayout < ActiveRecord::Base
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  belongs_to :raster
  
  has_many :telements, :class_name => "Telement", :foreign_key => "tlayout_id", :dependent => :destroy
  
  has_many :all_elements, :class_name => "Telement", :foreign_key => "this_layout"
  has_many :all_contents, :class_name => "Tcontent", :foreign_key => "this_layout"
  
  
  # =====> S C O P E S <======================================================== #
  default_scope :order => "name ASC"
  
  
  # =====> A T T R I B U T E S <======================================================== #
  attr_accessible :name, :description, :raster_id
  
  
  # =====> V A L I D A T I O N <======================================================== #
  validates :name, :raster_id, :presence => true
  validates :name, :uniqueness => true
  
  
  
end
