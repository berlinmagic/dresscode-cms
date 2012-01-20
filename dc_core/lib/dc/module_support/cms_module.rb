# encoding: utf-8
module DC
  module ModuleSupport
    module CmsModule

      @@module_classes = []
      @@modules = nil

      class << self
        # Adds a listener class.
        # Automatically called when a class inherits from DC::ModuleSupport::Listener.
        def add_listener(klass)
          raise "Modul must include Singleton" unless klass.included_modules.include?(Singleton)
          @@module_classes << klass
          clear_module_instances
        end

        # Returns all the listerners instances.
        def modules
          # => @@fine_modules ||= @@fine_module_classes.uniq.collect {|listener| listener.instance}
          DC::ModuleSupport::Listener.subclasses.each do |theme_class|
            theme_class
          end
        end

        # Clears all the listeners.
        def clear_module_classes
          @@module_classes = []
          clear_module_instances
        end
        
        # Clears all the listeners instances.
        def clear_module_instances
          @@modules = nil
        end
    
      end
      
    end
    
  end
end