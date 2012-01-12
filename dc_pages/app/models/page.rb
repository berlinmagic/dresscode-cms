# encoding: utf-8
class Page < ActiveRecord::Base
  
  def initialize(*args)
    super(*args)
    last_page = Page.last
    self.position = last_page ? last_page.position + 1 : 0
  end
  
  # =====> C O N S T A N T S <======================================================== #
  HEADLINE_TYPES = %w[name headline none]
  SITE_TYPES = %w[system page module]
  
  
  # =====> S C O P E S <======================================================== #
  scope :nav_system,    where("in_system_nav = ? AND is_draft = ? AND deleted_at = ?", true, false, nil)
  scope :nav_main,      where("in_main_nav = ? AND is_draft = ? AND deleted_at = ?", true, false, nil)
  scope :nav_sec,       where("in_sec_nav = ? AND is_draft = ? AND deleted_at = ?", true, false, nil)
  scope :draft,         where("is_draft = ? AND deleted_at = ?", true, nil)
  scope :aktiv,         where("is_draft = ? AND deleted_at = ?", false, nil)
  scope :dc,            where("is_draft = ? AND deleted_at = ?", false, nil)
  scope :deleted,       where("deleted_at != ?", nil)
  scope :sitemap,       where("system_seite = ? OR entwurf = ? AND deleted = ?", true, false, false)
  scope :systemsite,    lambda { |name| where("system_name = ? AND deleted = ?", name, false) }
  
  default_scope :order => "position ASC"
  
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  has_many      :abschnitte,      :dependent => :destroy
  accepts_nested_attributes_for   :abschnitte,              :allow_destroy => true
  
  has_many      :sub_sites,       :class_name => 'Page',   :foreign_key => :parent_site_id
  belongs_to    :parent_site,     :class_name => 'Page',   :foreign_key => :parent_site_id
  belongs_to    :main_site,       :class_name => 'Page',   :foreign_key => :main_site_id
  
  belongs_to    :group
  belongs_to    :author,           :class_name => 'User',    :foreign_key => :author_id
  belongs_to    :last_author,      :class_name => 'User',    :foreign_key => :last_author_id
  
  # => belongs_to    :tlayout,         :class_name => 'Tlayout',    :foreign_key => :tlayout_id
  
  
  # => acts_as_list
  
  
  # =====> A T T R I B U T E S <======================================================== #
  attr_accessible     :name,  :use_titel, :titel, :headline_type, :headline, :slug,
                      :site_type, :type_param, :system_name, :modul_type, :modul_id, 
                      :meta_description, :meta_keywords, 
                      :fowarding_site, :external_link, 
                      :tlayout_id, 
                      :in_main_nav, :in_system_nav, :in_sec_nav, 
                      :protected_stuff, :group, 
                      :spread_site, :deleted_at, :is_draft, :breadcrumps, 
                      :parent_site_id
  
  attr_protected      :full_slug,         :std_slug,
                      :position,          :site_level,
                      :autor_id,          :last_autor_id,
                      :main_site_id
  
  attr_accessor       :this_autor,        :version_id,          :yml_form
  
  
  # =====> V A L I D A T I O N <======================================================== #
  validates_presence_of       :name
  validates_uniqueness_of     :name, :full_slug, :slug, :std_slug, :case_sensitive => false
  validates_exclusion_of      :name,    :in => %w( admin sitemap seiten users login logout system ), 
                                        :message => I18n.t("Keine_standard_Seitennamen_verwenden")
  
  
  # =====> F I L T E R <======================================================== #
  before_validation   :felder_fuellen, :make_position
  
  # =====> F U N C T I O N s <======================================================== #
  def link
    # => slug_link(self.name)
    if self.fowarding_site && self.external_link && !self.external_link.blank?
      self.external_link
    elsif self.spread_site
      '#'
    else
      if self.parent_site
        full_slug.to_slash
      else
        slug.to_slash
      end
    end
  end
  
  def is_deleted?
    if !self.deleted_at.blank?
      true
    else
      false
    end
  end
  
  # =====> P R I V A T E - F U N C T I O N s <======================================================== #
  private
    
    def make_position
      unless new_record?
        return unless prev_position = Page.find(self.id).position
        unless self.position.nil?
          if prev_position > self.position
            Page.update_all("position = position + 1", ["? <= position AND position < ?", self.position, prev_position])
          elsif prev_position < self.position
            Page.update_all("position = position - 1", ["? < position AND position <= ?", prev_position,  self.position])
          end
        end
      end
    end
    
    def felder_fuellen
      self.name         =   self.name.strip
      self.title        =   self.name.titleize          unless  self.use_title
      self.headline     =   self.name.titleize          unless  self.headline_type == 'headline'
      unless ( self.site_type == 'system' ) && self.system_name && ( self.system_name == 'start' )
        self.slug         =   self.name.to_url
      end
      self.std_slug     =   self.name.to_url
    end
  
end

