  require "rails/all"
  require 'dresscode'
  
  require 'coffee_script'
  
  require 'paperclip'
  
  # => require 'evergreen/rails'
  # => require 'ruby-debug'
  
  require 'dc_editor/version'
  

  
module DcEditor
    class Engine < Rails::Engine

      config.autoload_paths += %W(#{config.root}/lib)

      def self.activate

        Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
          Rails.env == "production" ? require(c) : load(c)
        end

      end

      config.to_prepare &method(:activate).to_proc
      
      
      # Additional application configuration to include precompiled assets.
      initializer :assets do |config|
        Rails.application.config.assets.precompile += %w( dc_editor.js dc_editor.css dc_editor_overrides.css )
      end

      # To load the routes for this Engine, within your main apps routes.rb file include:
      #
      # DcEditor::Engine.routes
      #
      def self.routes
        Rails.application.routes.draw do
          match '/editor(/*requested_uri)' => "dc_editor#edit", :as => :dc_editor_editor

          namespace :dc_editor do
            resources :images
          end

          scope '/dc_editor' do
            match ':type/:resource' => "dc_editor#resource"
            match 'snippets/:name/options' => "dc_editor#snippet_options"
            match 'snippets/:name/preview' => "dc_editor#snippet_preview"
          end

          if defined?(DcEditor::Application)
            match 'dc_editor/test_page' => "dc_editor#test_page"
          end
        end
      end

    end
end