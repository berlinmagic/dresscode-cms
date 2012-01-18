module DcCore
  class Engine < Rails::Engine
    
    
    config.autoload_paths += %W(#{config.root}/lib)
    
    # TODO - register state monitor observer?

    def self.activate
      
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
      
      attr_accessor :configuration

      # Call this method to modify defaults in your initailizers.
      #
      #   Lacquer.configure do |config|
      #     config.varnish_servers << { :host => '0.0.0.0', :port => 6082, :timeout => 5 }
      #   end
      def configure
        self.configuration ||= Configuration.new
        yield(configuration)
      end
    
    end

    config.to_prepare &method(:activate).to_proc

  end
end