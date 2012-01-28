# encoding: utf-8
module DC
  module ModuleSupport
    require 'singleton'
    # Listener class for Module-Extensions
    class Listener
      include Singleton
    
      attr_accessor :modules, :installable_modules
      
      def initialize
        # => @modules = []
        # => @installable_modules = []
      end
      
      
      def self.installable?
        false
      end
      
      def self.updatable?
        false
      end
      
      def self.core?
        false
      end
      
      def self.theme?
        false
      end
      
      def do_mirror? 
        false
      end
      
      def mirror(*args)
        vars = %w[assets public views false]
        this = []
        args.each do |value|
          if vars.include?(value.to_s)
              this << value
          end
        end
        def do_mirror?
          this.empty? ? false : this
        end
      end
      
      def self.mirror_views?
        false
      end
      
      def self.mirror_theme?
        false
      end
      
      def self.mirror_public?; true; end
      
      def self.sample_seed?
        false
      end
      
      
      def self.modul_name
        "#{ self.to_s.gsub(/Module$/, '') }"
      end
      
      def self.gem_name
        "#{ self.to_s.gsub(/Module$/, '').underscore }"
      end
      
      def self.version
        # => if self.to_s.gsub(/Modul$/, '').constantize.respond_to?('VERSION')  const_defined
        if self.to_s.gsub(/Module$/, '').constantize.const_defined?('VERSION')  
          self.to_s.gsub(/Module$/, '').constantize::VERSION.to_s
        else
          DC.version
        end
      end
      
      # Replace defaults with Module-Values
      def self.install(wert=true)
          if wert
            def self.installable?
              true
            end
          end
      end
      
      def self.update(wert=true)
          if wert
            def self.updatable?
              true
            end
          end
      end
      
      def self.core(wert=true)
          if wert
            def self.core?
              true
            end
          end
      end
      
      def self.theme(wert=true)
          if wert
            def self.theme?
              true
            end
          end
      end
      
      def self.sample_seed(wert=true)
          if wert
            def self.sample_seed?
              true
            end
          end
      end
      
      def self.mirror_theme(wert=true)
          if wert
            def self.mirror_theme?
              true
            end
          end
      end
      
      def self.mirror_public(wert=true)
          if wert
            def self.mirror_public?
              true
            end
          end
      end
      
      def self.mirror_views(wert=true)
          if wert
            def self.mirror_views?
              true
            end
          end
      end
      
    end
  end
end