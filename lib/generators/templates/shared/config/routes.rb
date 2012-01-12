Rails.application.routes.draw do
  
  # => your routes
  namespace :dc_admin do
    # => your Admin-routes
    namespace :settings do
      # => your Settings-routes
    end
  end
  namespace :dc_system do
    # => your system-routes
  end
  
end
