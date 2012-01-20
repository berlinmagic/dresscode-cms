# encoding: utf-8
## => inspired by Spree  (  https://github.com/spree/spree  &  http://spreecommerce.com/  )  ... thanks a lot !!!
module DC
  module Setters
    # This class handles CORE settings using preferences feature available in dc_core.
    class CoreSetter

      class << self

        # When loading from config/initializers/dresscode.rb the logger
        # variable is not available yet, so defining it here.
        def logger
          ::Rails.logger
        end

        def init
          # Set mail server settings from preferences
          begin
            logger.info "INFO: Loading Core-Setter"

            Rails.application.config.time_zone = "#{ DC::Config[:time_zone].blank? ? 'Berlin' : DC::Config[:time_zone] }"
            
            Rails.application.config.i18n.default_locale = DC::Config[:default_locale]
            
            Rails.application.config.encoding = "utf-8" 
            
            Time.zone = "#{ DC::Config[:time_zone].to_s }"
            
            
            
          rescue
            logger.error "========================================================================="
            logger.error "   ! ! ! ERROR: Something went wrong while loading Core-Settings ! ! !"
            logger.error "   Check configuration in .. dc_core/lib/dresscode/setters/core_setter"
            logger.error "========================================================================="
          end
        end 
      end
    end
  end
end