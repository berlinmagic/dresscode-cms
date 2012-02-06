# encoding: utf-8
module DcCarte
  module Routes
    
    def dresscode_carte_routes
      resources :cartes do
        resources :sub_cartes
      end
      resources :carte_entries
    end
    
    def public_carte_routes
      
      # => if Page.where("system_name = ? AND deleted_at = ?", 'carte', nil).count > 0
      # =>   resources :public_cartes, :path => Page.where('system_name = ?', 'carte').first.link
      # => end
      
      resources :public_cartes, :path => Page.where('system_name = ?', 'carte').first.link, :only => :index do
        collection do
          match '/:carte'                         => 'public_cartes#show_carte'
          match '/:carte/:sub_carte'              => 'public_cartes#show_carte'
          match '/:carte/:sub_carte/:carte_entry' => 'public_cartes#show_carte'
        end
      end
      
      # => match "/*carte_slug" => 'public_cartes#show_carte_page', :constraints => DcCartePass.new
      
    end
    
  end
end
module ActionDispatch::Routing
  class Mapper #:nodoc:
    include DcCarte::Routes
  end
end

