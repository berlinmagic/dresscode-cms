# encoding: utf-8
require 'rails/generators/migration'

module DcEditor
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root DcEditor::Engine.root

      desc "Installs DcEditor into your application by copying the configuration file."

      def self.next_migration_number(path)
        @prev_migration_nr ? @prev_migration_nr += 1 : @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        @prev_migration_nr.to_s
      end

      def copy_migrations
        puts("Core:: erstelle Migrations")
        Dir.glob( File.join(File.expand_path("#{DcEditor::Engine.root}/db/templates", __FILE__), "*.*") ) do |file|
          migration_template "#{file}", "db/migrate/#{File.basename(file.to_s)}"
        end
      end

      # => def copy_config
      # =>   copy_file 'vendor/assets/javascripts/dc_editor.js', 'app/assets/javascripts/dc_editor.js'
      # => end

      def add_routes
        route %Q{DcEditor::Engine.routes}
      end
      
      # => def editor_app_config_file
      # =>   application "config.assets.precompile = %w( mercury.js mercury.css mercury_overrides.css )"
      # => end
      
      def strange_mirror_assets
        source = File.join("#{ DcEditor::Engine.root }", 'public')
        destination = File.join(Rails.root, 'public')
        puts("DcEditor:: Spiegle Daten in public-Ordner")
        DC::FileUtilz.mirror_files(source, destination)
      end

      def copy_layout_and_css_overrides
          copy_file 'app/views/layouts/dc_editor.html.erb', 'app/views/layouts/dc_editor.html.erb'
          # => copy_file 'vendor/assets/stylesheets/dc_editor_overrides.css', 'app/assets/stylesheets/dc_editor_overrides.css'
      end

      def display_readme
        readme 'POST_INSTALL'
      end

    end
  end
end
