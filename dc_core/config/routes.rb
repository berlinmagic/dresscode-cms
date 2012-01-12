Rails.application.routes.draw do
  
  namespace :dc do
    
    
    namespace :admin do
      root :to => 'base#dashboard'
    end
    
    resources :settings do 
      collection do
        get  :info
        post :new_pref_pic
        post :update_pref_pic
      end
    end
    
    match '/locale/set' => 'locale#set'
    
    match '/dynamic_styles.:format' => "pipe#dynamic_style", :to_style => 'seite'
    
    match '/template_styles/tl_:id.:format' => "pipe#template_style"
    
    match '/dynamic_script/:script.:format' => "pipe#dynamic_script"
    
    match '/dynamic_script/lib/:script.:format' => "pipe#dynamic_script_lib"
    
    root :to => 'base#dashboard'
    
  end
  
  
end
