# encoding: utf-8
## => inspired by Spree  (  https://github.com/spree/spree  &  http://spreecommerce.com/  )  ... thanks a lot !!!
module DC
  module Setters
    # This class handles MAIL settings using preferences feature available in dc_core.
    class MailSetter

      class << self

        # When loading from config/initializers/dresscode.rb the logger
        # variable is not available yet, so defining it here.
        def logger
          ::Rails.logger
        end

        def init
          # Set mail server settings from preferences
          begin
            logger.info "INFO: Loading Mail-Setter"

            if DC::Config.instance.prefers_enable_mail_delivery?
              mail_server_settings = {
                :address => DC::Config[:mail_host],
                :domain => DC::Config[:mail_domain],
                :port => DC::Config[:mail_port],
              }

              if DC::Config[:mail_auth_type] != 'none'
                mail_server_settings[:authentication] = DC::Config[:mail_auth_type]
                mail_server_settings[:user_name] = DC::Config[:smtp_username]
                mail_server_settings[:password] = DC::Config[:smtp_password]
              end

              # Enable TLS
              if DC::Config[:secure_connection_type] == 'TLS'
                mail_server_settings[:enable_starttls_auto] = true
              end

              logger.info "INFO: Setting mails settings to #{mail_server_settings.inspect}"
              ActionMailer::Base.smtp_settings = mail_server_settings
              logger.info "INFO: Enabling mail delivery"
              ActionMailer::Base.perform_deliveries = true
              ActionMailer::Base.default_url_options = { :host => DC::Config[:site_url] }
              return true
            else
              logger.warn "NOTICE: Mail not enabled"
              ActionMailer::Base.perform_deliveries = false
              return false
            end
          rescue
            logger.error "========================================================================="
            logger.error "   ! ! ! ERROR: Something went wrong while loading Mail-Settings ! ! !"
            logger.error "   Check configuration in .. dc_core/lib/dresscode/setters/mail_setter"
            logger.error "========================================================================="
          end
        end 
      end
    end
  end
end