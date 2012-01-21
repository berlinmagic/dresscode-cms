# encoding: utf-8
class PageContent < ActiveRecord::Base
  # PageContent = Text-Content or every module given content
  
  def initialize(*args)
    super(*args)
    last_page = PageContent.last
    self.position = last_page ? last_page.position + 1 : 0
  end
  
  
  # =====> S C O P E S <======================================================== #
  scope :dcid, lambda { |uid| where("dc_uid = ?", uid) }
  
  default_scope :order => "position ASC"
  
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  belongs_to :page_cell, :class_name => "PageCell", :foreign_key => "page_cell_id"
  
  
  # => # =====> V A L I D A T I O N <======================================================== #
  # => validates_presence_of       :dc_uid
  # => validates_uniqueness_of     :dc_uid
  # => 
  # => 
  # => # =====> F I L T E R <======================================================== #
  # => before_validation :generate_unique_identifier
  after_create :generate_unique_identifier
  
  
private
  
  def generate_unique_identifier
    record = true
    while record
      random = "pcon_#{Array.new(7){rand(9)}.join}"
      record = PageContent.dcid( random ).count > 0 ? true : false
    end
    self.dc_uid = random
    self.save
  end
  
end
