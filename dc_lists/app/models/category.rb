# encoding: utf-8
class Category < ActiveRecord::Base
  
  has_many :categorizes, :dependent => :destroy
  has_many :targets, :through => :categorizes
  
  default_scope :order => "name ASC"
  
  before_validation :felder_fuellen
  
  validates :name, :presence => true, :uniqueness => true
  validates :slug, :uniqueness => true
  
  private

    def felder_fuellen
      self.name         = self.name.strip.downcase.titleize if self.name
      self.firstletter  = self.name.strip[0..0].upcase
      self.slug         = self.name.to_url
    end
  
end
