Rails.application.routes.draw do
  
  namespace :dc do
    
    
    match '/dc_script/dc_editor.:format' => "editor_pipe#load_editor_scripts"
    
    match '/dc_styles/dc_editor.:format' => "editor_pipe#load_editor_styles"
    
    
    match '/dc_script/dc_editor_loader.:format' => "editor_pipe#load_editor_loader_scripts"
    
  end
  
  
end
