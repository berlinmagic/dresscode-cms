# encoding: utf-8
module GlobalUser
  module InstanceMethods
    
    def user_check
      current_user ? true : false
    end

    # => def admin_check
    # =>   if current_user
    # =>     return true if current_user.evil_master
    # =>     return true if current_user.site_admin
    # =>     return true if (current_user.crew == 'admin') || (current_user.crew == 'owner')
    # =>   else
    # =>     false
    # =>   end
    # => end
    
    def admin_check
      if current_user
        return true if current_user.evil_master
        return true if current_user.site_admin
        return true if current_user.gruppe && current_user.gruppe.system_name && (current_user.gruppe.system_name == 'admin')
        return true if current_user.gruppe && current_user.gruppe.system_name && (current_user.gruppe.system_name == 'owner')
      else
        false
      end
    end
    
    # => def owner_check
    # =>   if current_user
    # =>     return true if current_user.evil_master
    # =>     return true if current_user.site_admin
    # =>     return true if current_user.crew && (current_user.crew == 'owner')
    # =>   else
    # =>     false
    # =>   end
    # => end
    
    def owner_check
      if current_user
        return true if current_user.evil_master
        return true if current_user.site_admin
        return true if current_user.gruppe && current_user.gruppe.system_name && (current_user.gruppe.system_name == 'owner')
      else
        false
      end
    end
    
    def authorized_admin
      unless admin_check
        # => flash.alert = 'Admin - Rechte erforderlich !'
        # => redirect_to root_path 
        redirect_to '/dc/login'
      end
    end
    
    def authorized_owner
      unless owner_check
        flash.alert = 'Nur dem Seiten-Inhaber gestattet!'
        redirect_to root_path 
      end
    end
    
    def strange_master
      if current_user
        current_user.evil_master ? true : false
      else
        false
      end
    end

    def site_master
      if current_user
        true if current_user.evil_master
        true if current_user.site_admin
      else
        false
      end
    end
    
    def user_rang(user = nil)
      user ||= current_user
      if user
        if user.evil_master
          rang = 'Master-Admin'
        elsif user.site_admin
          rang = 'Seiten-Admin'
        elsif user.gruppe
          rang = user.gruppe.name.to_s
        else
          rang = 'User'
        end
      else
        rang = 'Gast'
      end
      return rang
    end
    
    # => ?  # => ?  # => ?  # => ?  # => ?  # => ?  # => ?
    def strange_devise_error_messages!
      return "" if resource.errors.empty?
      messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
      sentence = I18n.t("errors.messages.not_saved",
                        :count => resource.errors.count,
                        :resource => resource_name.to_s.humanize.capitalize)
      html = <<-HTML
      <div id="error_explanation">
        <h2>#{sentence}</h2>
        <ul>#{messages}</ul>
      </div>
      HTML
      html.html_safe
    end

    def strange_devise_user_error_messages!
      return "" if @user.errors.empty?
      messages = @user.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
      sentence = I18n.t("errors.messages.not_saved",
                        :count => @user.errors.count,
                        :resource => User)
      html = <<-HTML
      <div id="error_explanation">
        <h2>#{sentence}</h2>
        <ul>#{messages}</ul>
      </div>
      HTML
      html.html_safe
    end
    # => ?  # => ?  # => ?  # => ?  # => ?  # => ?  # => ?
    def perform_my_time_string(time, period)
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
  
  def self.included(receiver)
    #receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    receiver.send :helper_method, 'user_check'
    receiver.send :helper_method, 'admin_check'
    receiver.send :helper_method, 'owner_check'
    receiver.send :helper_method, 'authorized_owner'
    receiver.send :helper_method, 'authorized_admin'
    receiver.send :helper_method, 'strange_master'
    receiver.send :helper_method, 'site_master'
    receiver.send :helper_method, 'user_rang'
    receiver.send :helper_method, 'strange_devise_error_messages!'
    receiver.send :helper_method, 'strange_devise_user_error_messages!'
    receiver.send :helper_method, 'perform_my_time_string'
  end

end