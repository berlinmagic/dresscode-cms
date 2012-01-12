# encoding: utf-8
module AdminBase
  module InstanceMethods
    
    # can be used in views as well as controllers.
    # e.g. <% title = 'This is a custom title for this view' %>
    attr_writer :title

    def title
      title_string = @title.blank? ? accurate_title : @title
      if title_string.blank?
        default_title
      else
        if DC::Config[:always_put_site_name_in_title]
          [default_title, title_string].join(' - ')
        else
          title_string
        end
      end
    end

    protected

      def default_title
        DC::Config[:site_name] + ' ' + I18n.t('backend')
      end

      # this is a hook for subclasses to provide title
      def accurate_title
        nil
      end


    private

      def redirect_back_or_default(default)
        redirect_to(session["user_return_to"] || default)
        session["user_return_to"] = nil
      end

  end

  def self.included(receiver)
    #receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    receiver.send :helper_method, 'title'
    receiver.send :helper_method, 'title='
  end
end