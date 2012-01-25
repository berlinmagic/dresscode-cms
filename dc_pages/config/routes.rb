Rails.application.routes.draw do
  
  namespace :dc do
    resources :pages do
      resources :page_rows
      collection do
        post :reorder_cells
        post :reorder_rows
        post :reorder_pages
      end
      member do
        post :mercury_update
      end
    end
    resources :page_rows do
      resources :page_cells
    end
    resources :page_cells do
      resources :page_contents
    end
    match "/page/*full_slug" => 'pages#show_editable_page', :constraints => DcEditPagePass.new
    match "/page" => 'pages#show_editable_root'
  end
  
  
  scope DC::Config[:pretty_namespace].to_s.downcase, :as => 'dcr', :module => "dc" do
    resources :pages do
      resources :page_rows
      collection do
        post :reorder_cells
        post :reorder_rows
        post :reorder_pages
      end
      member do
        post :mercury_update
      end
    end
    resources :page_rows do
      resources :page_cells
    end
    resources :page_cells do
      resources :page_contents
    end
    match "/page/*full_slug" => 'pages#show_editable_page', :constraints => DcEditPagePass.new
    match "/page" => 'pages#show_editable_root'
  end
  
  # => match '/:slug' => 'pages#show_seite', :constraints => DcPagePass.new
  # => match '/:slug1(/:slug2(/:slug3(/:slug4)))' => 'pages#show_seite', :constraints => DcPagePass.new
  
  match "/*full_slug" => 'public#show_page', :constraints => DcPagePass.new
  
  
  # => root :to => 'tlayouts#index'
  root :to => 'public#root_page',  :system_name => "start"
  
end
