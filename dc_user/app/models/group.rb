# encoding: utf-8
class Group < ActiveRecord::Base
  
  attr_accessible :name, :position, :admin
  attr_protected  :system_stuff, :rang
  
  has_many :users
  
  has_many :rights,           :dependent => :destroy
  has_many :right_modules,    :through => :rights
  
end