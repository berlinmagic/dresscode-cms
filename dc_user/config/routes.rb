Rails.application.routes.draw do
  
  # => devise_for :users do
  # =>   get "dc/login", :to => "devise/sessions#new"
  # =>   get "dc/logout", :to => "devise/sessions#destroy"
  # => end
  
  devise_for :users, 
              :path => "dc", 
              :path_names => { 
                        :sign_in => 'login',
                        :sign_out => 'logout',
                        :password => 'secret',
                        :confirmation => 'verification',
                        :unlock => 'unblock',
                        :registration => 'register',
                        :sign_up => 'sign_up' }
  
  namespace :dc do
    
    resources :user_settings
    match 'users' => 'user#index'
    match 'user_settings_update' => 'user_settings#update'
    match 'user_create' => 'user#create'
    
    # => devise_for :users do
    # =>   get "login", :to => "devise/sessions#new"
    # =>   get "logout", :to => "devise/sessions#destroy"
    # => end
  
  end
  
end



