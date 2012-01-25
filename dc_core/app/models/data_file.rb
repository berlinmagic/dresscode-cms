# encoding: utf-8
class DataFile < ActiveRecord::Base
  # DataFile is the place for all (uploaded-)Files .. mostly for images but also every other file-type
  
  IMAGE_EXTS = %w[bmp gif jpg jpeg png psd tif tiff] # =>  pdf
  
  has_many :attachments,  :dependent => :destroy
  has_many :targets,      :through => :attachments
  
  # => default_scope :order => "name ASC"
  
  scope :pix,         where( :image => true )
  scope :nopix,       where( :image => false )
  
  
  file_accessor :file
  validates_presence_of :file
  
  
  after_create :set_the_field_values
  # => after_save :set_more_field_values
  
  
  def generate_default_dc_name
    record = true
    while record
      random = "dcfile_#{Array.new(7){rand(9)}.join}"
      record = DataFile.where( :name => random ).count > 0 ? true : false
    end
    self.name = random
  end
  
private # => # => # => # => # => # => # => # => # => # => #
  
  def set_the_field_values
      fn = self.file_name
      ex = self.file_ext
      nm = self.name
      
      pic_name = fn.split('.')
      pic_name.delete(pic_name.last)
      
      pn = pic_name.join('_').to_s.to_go
      
      the_name = ( nm.blank? || nm.start_with?('dcfile_') ) ? pn.titleize : nm.to_s
      the_fname = !nm.blank? ? nm.to_s.to_go : pn
      
      self.name = the_name
      self.original_name = fn
      self.file_name = "#{the_fname}.#{ex}"
      self.image = IMAGE_EXTS.include?( ex.to_s.downcase ) ? true : false
      self.save
  end
  
  def set_more_field_values
    if self.file && !DC::Config[:strip_data_file_names]
      self.file.name = self.name.to_s.to_go unless self.name.start_with?('dcfile_')
    end
  end
  
end