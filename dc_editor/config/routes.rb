Rails.application.routes.draw do
  
  namespace :dc do
    
    match '/pipe/editor_script/dc_editor.:format' => "editor_pipe#load_editor_scripts"
    
    match '/pipe/editor_styles/dc_editor.:format' => "editor_pipe#load_editor_styles"
    
    match '/pipe/editor_script/dc_editor_loader.:format' => "editor_pipe#load_editor_loader_scripts"
    
    # outdated but maybe needed:
    match '/dc_script/dc_editor_loader.:format' => "editor_pipe#load_editor_loader_scripts"
    
  end
  
  
end
