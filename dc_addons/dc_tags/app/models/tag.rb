# encoding: utf-8
class Tag < ActiveRecord::Base
  
  has_many :taggings, :dependent => :destroy
  has_many :targets, :through => :taggings
  
  default_scope :order => "name ASC"
  
  before_validation :set_the_field_values
  
  validates :name, :presence => true, :uniqueness => true
  
  validates :slug, :uniqueness => true
  
  private

    def set_the_field_values
      self.name         = self.name.strip.downcase.titleize if self.name
      self.firstletter  = self.name.strip[0..0].upcase # saves time in views maybe will be moved in helper
      self.slug         = self.name.to_url
    end
  
end
