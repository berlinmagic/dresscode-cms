Rails.application.routes.draw do
  
  namespace :dc do
    dresscode_contactform_routes
  end
  
  scope DC::Config[:pretty_namespace].to_s.downcase, :as => 'dcr', :module => "dc" do
    dresscode_contactform_routes
  end
  
end
