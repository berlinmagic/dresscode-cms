Rails.application.routes.draw do
  
  # find your routes in: lib/dc_tags/routes
  
  namespace :dc do
    dresscode_tags_routes
  end
  
  scope DC::Config[:pretty_namespace].to_s.downcase, :as => 'dcr', :module => "dc" do
    dresscode_tags_routes
  end

  public_tags_routes
  
end
