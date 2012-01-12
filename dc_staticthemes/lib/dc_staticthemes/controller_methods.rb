module DcStaticthemes
  module ControllerMethods
    extend ActiveSupport::Concern
    included do
      include DcStaticthemes::CommonMethods
      include DcStaticthemes::UrlHelpers
    end
    module ClassMethods
      def theme(name, options = {})
        before_filter(options) do |controller|
          controller.set_theme(name)
        end
      end
    end
    module InstanceMethods
      def theme(name)
        set_theme(name)
      end
    end
  end
end

ActiveSupport.on_load(:action_controller) { include DcStaticthemes::ControllerMethods }

ActiveSupport.on_load(:action_mailer) { include DcStaticthemes::ControllerMethods }

