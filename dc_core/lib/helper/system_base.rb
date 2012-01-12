# encoding: utf-8
module SystemBase
  module InstanceMethods
    
    #   #   #   #   #   #   #   #   #   #   #   #   # 
    
  end

  def self.included(receiver)
    #receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    #receiver.send :helper_method, 'bla'
  end
  
end