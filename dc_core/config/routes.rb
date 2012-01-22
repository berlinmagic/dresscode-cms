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
  
  scope DC::Config[:pretty_namespace].to_s.downcase, :as => 'dcr', :module => "dc" do
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
  
  namespace :pipe do
    
    match '/script/library/:script.:format' => "scriptz#library"
    match '/script/public/:theme.:format' => "scriptz#public"
    match '/script/dc_libs.:format' => "scriptz#dc_js"
    match '/script/dtheme.:format' => "scriptz#dtheme"
    
    match '/styles/public/:theme.:format' => 'stylez#public'
    match '/styles/dc/libs.:format' => 'stylez#dc_style'
    match '/styles/dynamic/template/tl_:id.:format' => 'stylez#dynamic_template'
    match '/styles/dynamic/:style.:format' => 'stylez#dynamic_dc_style'
    
  end
  
  
end
