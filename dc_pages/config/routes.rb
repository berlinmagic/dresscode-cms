Rails.application.routes.draw do

  resources :pages do
    member do
      post :mercury_update
    end
  end
  
  
  match '/:slug' => 'pages#show_seite', :constraints => DcPagePass.new
  
  match '/:slug1(/:slug2(/:slug3(/:slug4)))' => 'pages#show_seite', :constraints => DcPagePass.new
  
  # => root :to => 'tlayouts#index'
  root :to => 'pages#show_seite',  :system_name => "start"
  
end
