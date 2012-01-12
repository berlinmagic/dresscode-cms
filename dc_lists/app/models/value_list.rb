# encoding: utf-8
class ValueList < ActiveRecord::Base
  
  has_many :values
  
  
  validates :name, :presence => true, :uniqueness => true
  
  
  
end