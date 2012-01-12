# encoding: utf-8
module GlobalBase
  module InstanceMethods
    
    
    
  end

  def self.included(receiver)
    receiver.send :include,         InstanceMethods
    # => receiver.send :helper_method,   'hook'
    receiver.send :helper,          'stuff'
  end
  
end