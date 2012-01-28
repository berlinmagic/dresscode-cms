Rails.application.routes.draw do
  
  # find your routes in: lib/dc_header/routes
  
  namespace :dc do
    dresscode_header_routes
  end
  
  scope DC::Config[:pretty_namespace].to_s.downcase, :as => 'dcr', :module => "dc" do
    dresscode_header_routes
  end

  public_header_routes
  
end
