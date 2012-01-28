Rails.application.routes.draw do
  
  # find your routes in: lib/dc_pic_slider/routes
  
  namespace :dc do
    dresscode_pic_slider_routes
  end
  
  scope DC::Config[:pretty_namespace].to_s.downcase, :as => 'dcr', :module => "dc" do
    dresscode_pic_slider_routes
  end

  public_pic_slider_routes
  
end
