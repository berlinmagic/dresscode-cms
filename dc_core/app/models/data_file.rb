# encoding: utf-8
class DataFile < ActiveRecord::Base
  
  # DataFile is the place for all (uploaded-) Data
  
  has_many :attachments,  :dependent => :destroy
  has_many :targets,      :through => :attachments
  
  default_scope :order => "name ASC"
  
  
  image_accessor :file
  validates_presence_of :file
  
  
  before_save :set_paramatas
  
  private
	
	  def set_paramatas
	    if self.file
  	    if xy_pic = self.file.name.split('.')
  	      self.oname = self.file.name
  	      xy_pic.delete(xy_pic.last)
  	      unless self.name && self.name != ''
  	        self.name = xy_pic.last
  	      end
  	    end
  	    self.mime_type  = self.file.mime_type
        self.file_type  = self.file.format
        self.image      = self.file.image?
  	  end
  	end
  
end