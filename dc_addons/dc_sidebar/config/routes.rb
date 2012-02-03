Rails.application.routes.draw do
  
  # find your routes in: lib/dc_sidebar/routes
  
  namespace :dc do
    dresscode_sidebar_routes
  end
  
  scope DC::Config[:pretty_namespace].to_s.downcase, :as => 'dcr', :module => "dc" do
    dresscode_sidebar_routes
  end

  public_sidebar_routes
  
end
