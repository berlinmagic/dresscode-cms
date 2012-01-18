class TagList < ActiveRecord::Base
  
  # =====> C O N S T A N T S <======================================================== #
  TYPES = %w[tag html_attr data_attr]
  COUNT = %w[multi one]
  
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  has_many :tdatas, :class_name => "TagAssignment", :foreign_key => "the_tag"
  has_many :tag_datas, :through => :tdatas, :class_name => "TagList"
  
  has_many :dtags, :class_name => "TagAssignment", :foreign_key => "the_data"
  has_many :data_tags, :through => :dtags, :class_name => "TagList"
  
  has_many :telements, :class_name => "Telement"
  
  
  # =====> S C O P E S <======================================================== #
  scope :is_tag, where('tag_type = ?', 'tag')
  scope :is_data, where('tag_type = ?', 'data_attr')
  scope :is_attr, where('tag_type = ?', 'html_attr')
  
  default_scope :order => "name ASC"
  
  
  # =====> A T T R I B U T E S <======================================================== #
  attr_accessible :name, :tag, :description, :tag_type, :system_stuff
end
