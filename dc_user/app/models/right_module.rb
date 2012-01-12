# encoding: utf-8
class RightModule < ActiveRecord::Base
  
  attr_accessible :name, :front_url, :admin_url, :prefs_url
  #attr_protected :evil_master, :strange_id
  
  has_many  :rights
  has_many  :groups
  
end