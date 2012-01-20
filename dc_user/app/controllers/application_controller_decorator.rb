# encoding: utf-8
ApplicationController.class_eval do

  include GlobalUser
  
  # => before_filter :store_location
  
  private
  
  # => def store_location
  # =>     session[:user_return_to] = request.url unless params[:controller] == "devise/sessions"
  # =>     # If devise model is not User, then replace :user_return_to with :{your devise model}_return_to
  # => end

  def after_sign_in_path_for(resource)
      # => stored_location_for(resource) || root_path
      dcr_root_path
  end
  
  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

end