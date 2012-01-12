# encoding: utf-8
class Right < ActiveRecord::Base
  
  attr_accessible     :show, :new, 
                      :edit_own, :edit_group, :edit_all, 
                      :del_own, :del_group, :del_all, 
                      :modify, :group_id, :right_module_id
  #attr_protected :evil_master, :strange_id
  
  belongs_to  :group
  belongs_to  :right_modules
  
  belongs_to  :user
  
end