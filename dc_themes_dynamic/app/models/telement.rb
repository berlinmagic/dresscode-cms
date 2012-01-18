class Telement < ActiveRecord::Base
  
  # =====> C O N S T A N T S <======================================================== #
  TYPES = %w[box grid_row grid_cell area tag]
  UNITS = %w[pixel percent]
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  belongs_to :tlayout, :class_name => "Tlayout", :foreign_key => "tlayout_id"
  belongs_to :telement, :class_name => "Telement", :foreign_key => "telement_id"
  belongs_to :tag_list, :class_name => "TagList", :foreign_key => "tag_list_id"
  belongs_to :master_layout, :class_name => "Tlayout", :foreign_key => "this_layout"
  
  has_many :element_childs, :class_name => "Telement", :foreign_key => "telement_id", :dependent => :destroy
  has_many :content_childs, :class_name => "Tcontent", :foreign_key => "telement_id", :dependent => :destroy
  
  has_many :styles, :as => :target
  
  has_many :class_assigments, :as => :target
  has_many :style_classes, :through => :class_assigments
  
  
  
  # =====> S C O P E S <======================================================== #
  scope :by_cmsid, lambda { |name| where("cms_ident = ?", name) }
  
  default_scope :order => "position ASC"
  
  
  # =====> A T T R I B U T E S <======================================================== #
  attr_accessible :name, :cms_ident, :position, :columns, :element_type, :element_level, :this_width, :w_unit, :use_raster, 
                  :tag_list_id, :tlayout_id, :telement_id, :this_layout
  
  attr_accessor :spalten
  
  
  # =====> F I L T E R <======================================================== #
  after_create :make_field_content
  
  
  # =====> F U N K T I O N E N <======================================================== #
  def tag
    self.tag_list ? self.tag_list.tag : 'div'
  end
  
  private
    
    def make_field_content
      generate_cms_id
      build_element_attributs
    end
    
    def generate_cms_id
      record = true
      while record
        random = "tle_#{Array.new(7){rand(9)}.join}"
        record = Telement.by_cmsid( random ).count > 0 ? true : false
      end
      self.cms_ident = random
      self.save
    end
    
    def build_element_attributs
      if self.tlayout
        self.element_level = 0
        self.this_layout = self.tlayout.id
      elsif self.telement
        self.element_level = self.telement.element_level.to_i + 1
        self.this_layout = self.telement.this_layout
      end
      if ( self.element_type == 'grid_row' ) || ( self.element_type == 'grid_cell' )
        self.use_raster = true
      else
        self.use_raster = false
      end
      self.save
    end
  
  
end
