# encoding: utf-8
class PageRow < ActiveRecord::Base
  # PageRows are Rows for the table-like Pagelayout
  
  def initialize(*args)
    super(*args)
    last_page = PageRow.last
    self.position = last_page ? last_page.position + 1 : 0
  end
  
  # =====> S C O P E S <======================================================== #
  scope :dcid, lambda { |uid| where("cms_ident = ?", uid) }
  
  default_scope :order => "position ASC"
  
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  belongs_to :page, :class_name => "Page", :foreign_key => "page_id"
  
  has_many :page_cells, :foreign_key => "page_row_id", :dependent => :destroy
  has_many :page_contents, :through => :page_cells
  accepts_nested_attributes_for   :page_cells,  :allow_destroy => true
  
  
  # =====> V A L I D A T I O N <======================================================== #
  validates_presence_of       :dc_uid
  validates_uniqueness_of     :dc_uid
  
  
  # =====> F I L T E R <======================================================== #
  before_validation :generate_unique_identifier
  
  
  
private
  
  def generate_unique_identifier
    record = true
    while record
      random = "prow_#{Array.new(7){rand(9)}.join}"
      record = PageRow.by_cmsid( random ).count > 0 ? true : false
    end
    self.dc_uid = random
    self.save
  end
  
end
