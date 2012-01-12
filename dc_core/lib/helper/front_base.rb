# encoding: utf-8
module FrontBase
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
          if DC::Config[:put_site_name_bevore_title]
            "#{default_title} #{title_seperator} #{title_string}"
          else
            "#{title_string} #{title_seperator} #{default_title}"
          end
        else
          title_string
        end
      end
    end
    
    def meta_keywords
      if @meta_keywords
        @meta_keywords
      else
        DC::Config[:meta_keywords]
      end
    end
    
    def meta_description
      if @meta_description
        @meta_description
      else
        DC::Config[:meta_description]
      end
    end
    
    def meta_app
      if @meta_app
        @meta_app
      else
        DC::Config[:meta_app]
      end
    end
    
    def meta_author
      if @meta_author
        @meta_author
      else
        DC::Config[:meta_author]
      end
    end
    
    def meta_generator
      if @meta_generator
        @meta_generator
      else
        DC::Config[:meta_generator]
      end
    end

    protected
    
        def accurate_title
          return nil
        end
    
        def title_seperator
          DC::Config[:title_seperator]
        end

        def default_title
          DC::Config[:site_name]
        end

    private

        def redirect_back_or_default(default)
          redirect_to(session["user_return_to"] || default)
          session["user_return_to"] = nil
        end
    
  end

  def self.included(receiver)
    receiver.send :include,       InstanceMethods
    receiver.send :helper_method, 'title'
    receiver.send :helper_method, 'title='
    receiver.send :helper_method, 'meta_keywords'
    receiver.send :helper_method, 'meta_description'
    receiver.send :helper_method, 'meta_app'
    receiver.send :helper_method, 'meta_author'
    receiver.send :helper_method, 'meta_generator'
  end
  
end