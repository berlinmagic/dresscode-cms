Rails.application.routes.draw do
  
  namespace :dc do
    dresscode_core_routes
  end
  
  scope DC::Config[:pretty_namespace].to_s.downcase, :as => 'dcr', :module => "dc" do
    dresscode_core_routes
  end
  
  dresscode_pipe_routes
  
end
