Rails.application.routes.draw do
  
  
  resources :pages do
    member do
      post :mercury_update
    end
  end
  
  namespace :dc do
    
    resources :pages do
      member do
        post :mercury_update
      end
    end
    
    
    
    match "/page/*full_slug" => 'pages#show_editable_page', :constraints => DcEditPagePass.new
    match "/page" => 'pages#show_editable_root'
  
  end
  
  match "/dc/page/*full_slug" => 'dc/pages#show_editable_page', :constraints => DcEditPagePass.new
  
  # => match '/:slug' => 'pages#show_seite', :constraints => DcPagePass.new
  # => 
  # => match '/:slug1(/:slug2(/:slug3(/:slug4)))' => 'pages#show_seite', :constraints => DcPagePass.new
  
  
  match "/*full_slug" => 'public#show_seite', :constraints => DcPagePass.new
  
  
  
  # => root :to => 'tlayouts#index'
  root :to => 'pages#show_seite',  :system_name => "start"
  
end
