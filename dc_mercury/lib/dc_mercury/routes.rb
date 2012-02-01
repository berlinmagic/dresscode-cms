# encoding: utf-8
module DcMercury
  module Routes
    
    def dc_mercury_editor_routes
      
      match '/editor(/*requested_uri)' => "dc_mercury#edit", :as => :dc_mercury_editor
      
      match '/epipe/*requested_source' => "editor_pipe#load_editor_pipe"
      
      namespace :dc_mercury do
        resources :images
      end
      
      scope '/dc_mercury' do
        match ':type/:resource' => "dc_mercury#resource"
        match 'snippets/:name/options' => "dc_mercury#snippet_options"
        match 'snippets/:name/preview' => "dc_mercury#snippet_preview"
      end
      
    end
    
  end
end
module ActionDispatch::Routing
  class Mapper #:nodoc:
    include DcMercury::Routes
  end
end

