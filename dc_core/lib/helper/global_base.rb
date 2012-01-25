# encoding: utf-8
module GlobalBase
  module InstanceMethods
    
    def themed_path( path )
      if DC::Config[:theme_type] == 'dynamic'
        "dynamic/#{path}"
      else
        "static/#{path}"
      end
    end
    
    def nice_route( objekt )
      if DC::Config[:nice_routing]
        [:dcr, objekt]
      else
        [:dc, objekt]
      end
    end
    
  end

  def self.included(receiver)
    receiver.send :include,         InstanceMethods
    receiver.send :helper_method,   'themed_path'
    receiver.send :helper_method,   'nice_route'
    receiver.send :helper,          'stuff'
    receiver.send :helper,          'icon'
  end
  
end