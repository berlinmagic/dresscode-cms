Rails.application.routes.draw do
  
  devise_for :users do
    get "dc/login", :to => "devise/sessions#new"
    get "dc/logout", :to => "devise/sessions#destroy"
  end
  
  namespace :dc do
    
    resources :user_settings
    match 'users' => 'user#index'
    match 'user_settings_update' => 'user_settings#update'
    match 'user_create' => 'user#create'
    
  end
  
end



