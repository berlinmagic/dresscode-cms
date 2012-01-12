# encoding: utf-8
class DcUserHooks < HookSupport::HookListener

  
  replace :login_buttons, :partial => "devise/menu/login_items"
  
  replace :admin_login_buttons, :partial => "devise/menu/login_items"
  
  insert_after :after_system_navigation, :partial => "devise/menu/login"
  
  # => replace :user_part do
  # =>   "<% if admin_check %>
  # =>     <%= render 'navigation/user' %>
  # =>    <% end %>"
  # => end
  
  insert_after :admin_main_right_navigation do
    "<%= link_to 'User', admin_users_url, :class => ('aktiv' if @aktivio == 'user') %>"
  end
  
  insert_after :admin_system_settings_sidebar do
    "<li><%= link_to 'Sicherheit', admin_user_settings_path, :class => ('aktiv' if @u_aktiv == 'user_settings') %></li>"
  end
  
  
end
