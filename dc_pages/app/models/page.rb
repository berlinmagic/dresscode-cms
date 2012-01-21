# encoding: utf-8
class Page < ActiveRecord::Base
  
  # Pages .. every visible Site should use a Page
  
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
  has_many :page_rows, :foreign_key => "page_id", :dependent => :destroy
  has_many :page_cells, :through => :page_rows
  # => has_many :page_contents, :through => :page_cells
  
  accepts_nested_attributes_for   :page_rows,  :allow_destroy => true
  
  has_many      :sub_sites,       :class_name => 'Page',   :foreign_key => :parent_site_id
  belongs_to    :parent_site,     :class_name => 'Page',   :foreign_key => :parent_site_id
  belongs_to    :main_site,       :class_name => 'Page',   :foreign_key => :main_site_id
  
  belongs_to    :group
  belongs_to    :author,           :class_name => 'User',    :foreign_key => :author_id
  belongs_to    :last_author,      :class_name => 'User',    :foreign_key => :last_author_id
  
  # only needed by dynamic themes
  belongs_to    :tlayout,         :class_name => 'Tlayout',    :foreign_key => :tlayout_id
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
  before_validation   :set_the_field_values
  after_save :relaunch_slug_listener
  
  
  # =====> F U N C T I O N s <======================================================== #
  def link
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
  
  def the_headline
    if self.headline_type == 'headline'
      !self.headline.blank? ? self.headline : self.name.titleize
    elsif self.headline_type == 'name'
      self.name.titleize
    else
      false
    end
  end
  
  def sidebars
    false
  end
  
  # =====> P R I V A T E - F U N C T I O N s <======================================================== #
private
  
  # Fill in all needed and system stuff
  def set_the_field_values
    self.name         =   self.name.strip
    self.title        =   self.name.titleize          unless  self.use_title
    self.headline     =   self.name.titleize          unless  self.headline_type == 'headline'
    # empty slug ('/') for start-page ... maybe replace with start-option & root_to page with start-option
    unless ( self.site_type == 'system' ) && self.system_name && ( self.system_name == 'start' )
      self.slug         =   self.name.to_url
    end
    # 'real'-slug ('/start') for start-page ... maybe replace with start-option & root_to page with start-option
    self.std_slug     =   self.name.to_url
    
    parent_site_check
    sub_sites_check
  end
  
  # Check if Parent-Site present and update slug entries
  def parent_site_check
    if self.parent_site
      self.full_slug      =   "#{ self.parent_site.full_slug }#{ self.std_slug }"
      self.site_level     =   self.parent_site.site_level + 1
      self.main_site_id   =   !self.parent_site.main_site_id.blank? ? self.parent_site.main_site_id : self.parent_site.id
    else
      self.full_slug      =   self.std_slug
      self.site_level     =   0
      self.main_site_id   =   nil
    end
  end
  
  # Check for Sub-Sites if present update the slugs of all of them
  def sub_sites_check
    if self.sub_sites.count > 0
      update_sub_sites( self )
    end
  end
  
  # Function to update slugs of sub-sites 
  def update_sub_sites( site )
    site.sub_sites.each do |the_sub_site|
      the_sub_site.full_slug      = "#{ site.full_slug }#{ the_sub_site.std_slug }"
      the_sub_site.site_level     = site.site_level + 1
      the_sub_site.main_site_id   = site.main_site_id
      the_sub_site.save!
      if the_sub_site.sub_sites.count > 0
        update_sub_sites( the_sub_site )
      end
    end
  end
  
  # Function to relaunch the app .. needed to restart the dynamic-routes
  def relaunch_slug_listener
    DcPagePass.new
    # => StrangeNewsRouterPass.new
    FileUtils.touch "#{Rails.root}/tmp/restart.txt"
  end 
  
end

