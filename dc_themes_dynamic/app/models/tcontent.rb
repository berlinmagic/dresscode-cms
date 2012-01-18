class Tcontent < ActiveRecord::Base
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  belongs_to :telement, :class_name => "Telement", :foreign_key => "telement_id"
  belongs_to :twidget, :class_name => "Twidget", :foreign_key => "twidget_id"
  belongs_to :master_layout, :class_name => "Tlayout", :foreign_key => "this_layout"
  
  
  # =====> S C O P E S <======================================================== #
  scope :by_cmsid, lambda { |name| where("cms_ident = ?", name) }
  
  default_scope :order => "name ASC"
  
  
  # =====> A T T R I B U T E S <======================================================== #
  attr_accessible :name, :cms_ident, :position, :columns, :text_content, :this_width, :w_unit, 
                  :tlayout_id, :telement_id, :this_layout, :twidget_id
  
  
    
  # =====> F I L T E R <======================================================== #
  after_create :make_field_content
  
  
  # =====> F U N K T I O N E N <======================================================== #
  private
    
    def make_field_content
      generate_cms_id
      build_element_attributs
    end
  
    def generate_cms_id
      record = true
      while record
        random = "tlc_#{Array.new(7){rand(9)}.join}"
        record = Tcontent.by_cmsid( random ).count > 0 ? true : false
      end
      self.cms_ident = random
      self.save
    end
    
    def build_element_attributs
      if self.telement
        self.this_layout = self.telement.this_layout
        self.columns = self.telement.columns if self.telement.columns
        self.this_width = self.telement.this_width if self.telement.this_width
        self.w_unit = self.telement.w_unit if self.telement.w_unit
        self.position = self.telement.content_childs.count + 1
      end
      self.save
    end
  
end
