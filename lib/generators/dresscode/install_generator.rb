# encoding: utf-8
require 'rails/generators/migration'
module Dresscode
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      include Thor::Actions
      desc "Creates a CMS basic structure."
      
      def initial_desc
        puts('   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *')
        puts('   -   -   -   -   -   -   -   -   D r e s s C o d e - C M S   -   -   -   -   -   -   -   -   -   -   -')
        puts('   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *')
      end
      
      puts('INFO: Suche nach standard index.html')
      
      def kill_index_html
        if File.exists?( File.join(Rails.root, 'public', 'index.html') )
          File.delete( File.join(Rails.root, 'public', 'index.html') )
          puts('INFO: standard index.html .. wurde gelöscht')
        else
          puts('INFO: keine standard index.html vorhanden')
        end
        if File.exist?( File.join(Rails.root, 'db', 'seeds.rb') )
          File.delete( File.join(Rails.root, 'db', 'seeds.rb') )
        end
        if File.exist?( File.join(Rails.root, 'db', 'sample_seeds.rb') )
          File.delete( File.join(Rails.root, 'db', 'sample_seeds.rb') )
        end
      end

      def install_core
        generate("dc_core:install")
        
        generate("dc_mercury:install")
        
        generate("dc_pages:install")
        generate("dc_themes_static:install")
        puts("***************************************************************************")
        puts("ToDo::  ASK for:  Dynamic-Themes intallieren? ... experimentell")
        puts("***************************************************************************")
        #if yes?("Dynamic-Themes intallieren? ... experimentell")
          generate("dc_themes_dynamic:install")
        #end
        generate("dc_user:install")
      end
      
      def install_optional_modules
        # => if !!defined?DcContactform
        # =>   puts("***************************************************************************")
        # =>   puts("ToDo::  ASK for:  Contactforms intallieren?")
        # =>   puts("***************************************************************************")
        # =>   generate("dc_contactform:install")
        # => end
        DC::ModuleSupport::CmsModule.modules.each do |modul|
          puts("***************************************************************************")
          puts("dresscode-Module:: #{ modul.modul_name }")
            unless modul.core? || modul.theme?
                generate("#{ modul.gem_name }:install") if modul.installable?
            end
        end
      end
      
      
      
      def edit_app_config_file
        application "config.time_zone = 'Berlin'"
        application "config.i18n.default_locale = :de"
      end
      

      def install_db_sample_data
        puts("***************************************************************************")
        puts("ToDo::  ASK for:  Beispiel-Daten intallieren?")
        puts("***************************************************************************")
        #if yes?("dresscode - Beispiel-Daten intallieren?")
          puts("DC:: Seed sample_data")
          open("#{Rails.root}/db/seeds.rb", 'a') do |f|
            f.puts File.read( "#{Rails.root}/db/sample_seeds.rb"  ).to_utf
          end
        #end
      end
      
      
      def install_development_db
        puts("***************************************************************************")
        puts("ToDo::  ASK for:  dresscode - Development-DB erstellen?")
        puts("***************************************************************************")
        #if yes?("dresscode - Development-DB erstellen?")
          puts("INFO: erstelle DB-Migration")
          rake("db:migrate")
          puts("INFO: erstelle DB-Beispieldaten")
          rake("db:seed")
        #end
      end
      
      def migrate_db_prod
        puts("INFO: erstelle production DB-Migration")
        rake("db:migrate", :env => "production")
      end
      
      def seed_db_prod
        puts("INFO: erstelle production DB-Beispieldaten")
        rake("db:seed", :env => "production")
      end
      
      def no_asset_pipe
        puts("INFO: Asset-Pipe deaktivieren !!!")
        gsub_file 'config/application.rb', "Bundler.require(*Rails.groups(:assets => %w(development test)))", "Bundler.require(:default, :assets, Rails.env)"
        gsub_file 'config/application.rb', "config.assets.enabled = true", "config.assets.enabled = false"
      end
      
      def end_desc
        puts("========================================================================================================")
        puts("-    -    -    -    -    -    -    -   D r e s s C o d e - C M S    -    -    -    -    -    -    -    -")
        puts("--------------------------------------------------------------------------------------------------------")
        puts("  .   .   .   Installation abgschlossen,  'rails s -e production'  startet Ihr neues CMS!   .   .   .   ")
        puts("========================================================================================================")
      end
      
    end
  end
end