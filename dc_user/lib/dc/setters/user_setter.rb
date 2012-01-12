# encoding: utf-8
## => inspired by Spree  (  https://github.com/spree/spree  &  http://spreecommerce.com/  )  ... thanks a lot !!!
module DC
  module Setters
    # This class handle mail settings using preferences feature available in spree core.
    class UserSetter
      
      class << self

        # When loading from config/initializers/spree.rb the logger
        # variable is not available yet, so defining it here.
        def logger
          ::Rails.logger
        end

        def init
          # Set mail server settings from preferences
          begin
            logger.info "INFO: Loading user preferences"

              Devise.mailer_sender = DC::User::Config[:mailer_sender]
              
              Devise.timeout_in = perform_my_timer(DC::User::Config[:timeout_in], DC::User::Config[:timeout_in_period])
              
              Devise.invite_for = perform_my_timer(DC::User::Config[:invite_for], DC::User::Config[:invite_for_period])
              Devise.confirm_within = perform_my_timer(DC::User::Config[:confirm_within], DC::User::Config[:confirm_within_period])
              Devise.remember_for = perform_my_timer(DC::User::Config[:remember_for], DC::User::Config[:remember_for_period])
              
              Devise.maximum_attempts = DC::User::Config[:maximum_attempts]
              
              Devise.lock_strategy = DC::User::Config[:lock_strategy]
              Devise.unlock_strategy = DC::User::Config[:unlock_strategy]
              
              Devise.unlock_in = perform_my_timer(DC::User::Config[:unlock_in], DC::User::Config[:unlock_in_period])


            
          rescue
            logger.error "========================================================================="
            logger.error "      ERROR: Something went wrong while loading user preferences"
            logger.error "   Verify you created a default configuration in admin/configurations"
            logger.error "========================================================================="
          end
        end 
        
        private
        
          def perform_my_timer(time, period)
            if period == 'minutes'
              time.minutes
            elsif period == 'hours'
              time.hours
            elsif period == 'days'
              time.days
            elsif period == 'weeks'
              time.weeks
            else
              time
            end
          end
      
      end
    end
  end
end