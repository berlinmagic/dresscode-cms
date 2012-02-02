Rails.application.routes.draw do
  
  # find your routes in: lib/dc_carte/routes
  
  namespace :dc do
    dresscode_carte_routes
  end
  
  scope DC::Config[:pretty_namespace].to_s.downcase, :as => 'dcr', :module => "dc" do
    dresscode_carte_routes
  end

  public_carte_routes
  
end
