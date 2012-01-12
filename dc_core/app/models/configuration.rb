# encoding: utf-8
## => inspired by Spree  (  https://github.com/spree/spree  &  http://spreecommerce.com/  )  ... thanks a lot !!!
class Configuration < ActiveRecord::Base
  
  validates :name, :presence => true, :uniqueness => true
  
end