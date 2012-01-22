# encoding: utf-8
class PageRow < ActiveRecord::Base
  # PageRows are Rows for the table-like Pagelayout
  
  CELL_TYPES = %w[r1c1 r2c11 r3c12 r3c111 r4c13 r4c112 r4c1111]
  
  def initialize(*args)
    super(*args)
    last_page = PageRow.last
    self.position = last_page ? last_page.position + 1 : 0
  end
  
  # =====> S C O P E S <======================================================== #
  scope :dcid, lambda { |uid| where("dc_uid = ?", uid) }
  
  default_scope :order => "position ASC"
  
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  belongs_to :page, :class_name => "Page", :foreign_key => "page_id"
  
  has_many :page_cells, :foreign_key => "page_row_id", :dependent => :destroy
  has_many :page_contents, :through => :page_cells
  accepts_nested_attributes_for   :page_cells,  :allow_destroy => true
  
  
  
  attr_accessor   :cells_type
  
  
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
      random = "prow_#{Array.new(7){rand(9)}.join}"
      record = PageRow.dcid( random ).count > 0 ? true : false
    end
    self.dc_uid = random
    self.save
  end
  
end
