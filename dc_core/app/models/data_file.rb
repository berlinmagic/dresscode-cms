# encoding: utf-8
class DataFile < ActiveRecord::Base
  # DataFile is the place for all (uploaded-)Files .. mostly for images but also every other file-type
  
  has_many :attachments,  :dependent => :destroy
  has_many :targets,      :through => :attachments
  
  default_scope :order => "name ASC"
  
  
  image_accessor :file
  validates_presence_of :file
  
  
  # => before_save :set_the_field_values
  
  private
	
	  def set_the_field_values
	    if self.file
  	    if xy_pic = self.file.name.split('.')
  	      self.filename = self.file.name
  	      xy_pic.delete(xy_pic.last)
  	      unless self.name && self.name != ''
  	        self.name = xy_pic.last
  	      end
  	    end
  	    # => self.mimetype  = self.file.mime_type if self.file.mime_type
        # => self.filetype  = self.file.format if self.file.format
        self.image     = self.file.image?
  	  end
  	end
  
end