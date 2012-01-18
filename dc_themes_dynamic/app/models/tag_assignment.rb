class TagAssignment < ActiveRecord::Base
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  belongs_to :the_data, :class_name => "Taglist", :foreign_key => "the_data"
  belongs_to :the_tag, :class_name => "Taglist", :foreign_key => "the_tag"
  
  # =====> S C O P E S <======================================================== #
  default_scope :order => "name ASC"
  
  
  # =====> A T T R I B U T E S <======================================================== #
  attr_accessible :the_tag, :the_data, :needed, :has_value
  
  
end
