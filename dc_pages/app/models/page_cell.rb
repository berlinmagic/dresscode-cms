# encoding: utf-8
class PageCell < ActiveRecord::Base
  # PageCells are Cells for the table-like Pagelayout
  
  CELL_TYPES = %w[1x1 1x2 1x3 2x3 1x4 2x4 3x4]
  
  def initialize(*args)
    super(*args)
    last_page = PageCell.last
    self.position = last_page ? last_page.position + 1 : 0
  end
  
  # =====> S C O P E S <======================================================== #
  scope :dcid, lambda { |uid| where("dc_uid = ?", uid) }
  
  default_scope :order => "position ASC"
  
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  belongs_to :page_row, :class_name => "PageRow", :foreign_key => "page_row_id"
  
  has_many :page_contents, :foreign_key => "page_cell_id", :dependent => :destroy
  accepts_nested_attributes_for   :page_contents,  :allow_destroy => true
  
  
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
      random = "pcell_#{Array.new(7){rand(9)}.join}"
      record = PageCell.dcid( random ).count > 0 ? true : false
    end
    self.dc_uid = random
    self.save
  end
  
end
