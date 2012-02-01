# encoding: utf-8
require 'rails/generators/migration'

module DcMercury
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
		
	    source_root DcMercury::Engine.root
      
      desc "Installs DcMercury into your application by copying the configuration file."
      
      def strange_mirror_assets
        source = File.join("#{ DcMercury::Engine.root }", 'public')
        destination = File.join(Rails.root, 'public')
        puts("DcMercury:: Spiegle Daten in public-Ordner")
        DC::FileUtilz.mirror_files(source, destination)
      end
      
      def copy_layout_and_css_overrides
        copy_file 'app/views/layouts/dc_mercury.html.erb', 'app/views/layouts/dc_mercury.html.erb'
      end

      def self.next_migration_number(path)
        @prev_migration_nr ? @prev_migration_nr += 1 : @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        @prev_migration_nr.to_s
      end

      def copy_migrations
        puts("DcMercury:: create Migrations")
        Dir.glob( File.join(File.expand_path("#{DcMercury::Engine.root}/db/templates", __FILE__), "*.*") ) do |file|
          migration_template "#{file}", "db/migrate/#{File.basename(file.to_s)}"
        end
      end
      
      def display_readme
        readme 'POST_INSTALL' if behavior == :invoke
      end

    end
  end
end