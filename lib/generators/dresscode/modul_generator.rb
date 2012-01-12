require 'rails/generators'

module Strangecms
  module Generators
    class ModulGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a new theme gem with the name you specify."
      check_class_collision

      def create_root_files
        empty_directory file_name
        empty_directory "#{file_name}/public"
        template "Rakefile.tt", "#{file_name}/Rakefile"
        template "README.md", "#{file_name}/README.md"
        template "gitignore.tt", "#{file_name}/.gitignore"
        template "modul.gemspec.tt", "#{file_name}/#{file_name}.gemspec"
      end

      def create_config_files
        empty_directory "#{file_name}/config"
        template "shared/config/routes.rb", "#{file_name}/config/routes.rb"
        empty_directory "#{file_name}/config/locales"
        template "shared/config/locales/de.yml", "#{file_name}/config/locales/de.yml"
        template "shared/config/locales/en.yml", "#{file_name}/config/locales/en.yml"
      end

      #def install_rake
      #  template "install.rake.tt", "#{file_name}/lib/tasks/install.rake"
      #end

      def create_app_dirs
        empty_directory "#{file_name}/app"
        empty_directory "#{file_name}/app/controllers"
        empty_directory "#{file_name}/app/helpers"
        empty_directory "#{file_name}/app/models"
        empty_directory "#{file_name}/app/views"
      end

      def create_lib_files
        empty_directory "#{file_name}/lib"
        template 'lib/modul.rb.tt', "#{file_name}/lib/#{file_name}.rb"
        template 'lib/version.rb.tt', "#{file_name}/lib/#{file_name}/version.rb"
        
        template 'lib/modul_hooks.rb.tt', "#{file_name}/lib/#{file_name}_hooks.rb"
        template 'lib/modul_modul.rb.tt', "#{file_name}/lib/#{file_name}_modul.rb"
        # => template 'lib/modul_theme.rb.tt', "#{file_name}/lib/#{file_name}_theme.rb"
        
        empty_directory "#{file_name}/lib/generators"
        empty_directory "#{file_name}/lib/generators/#{file_name}"
        template 'lib/install_generator.rb.tt', "#{file_name}/lib/generators/#{file_name}/install_generator.rb"
        template 'lib/update_generator.rb.tt', "#{file_name}/lib/generators/#{file_name}/update_generator.rb"
        empty_directory "#{file_name}/lib/generators/#{file_name}/templates"
        template 'lib/templates/create_modul.rb.tt', "#{file_name}/lib/generators/#{file_name}/templates/create_#{file_name}.rb"
        template 'lib/templates/update_modul.rb.tt', "#{file_name}/lib/generators/#{file_name}/templates/update_#{file_name}.rb"
        template 'lib/templates/seed_modul.rb.tt', "#{file_name}/lib/generators/#{file_name}/templates/seed_#{file_name}.rb"
      end

      #def create_spec_helper
      #  template "spec_helper.rb", "#{file_name}/spec/spec_helper.rb"
      #end
      #
      #def update_gemfile
      #  gem file_name, :path => file_name, :require => file_name
      #end

      protected

      def current_locale
        I18n.locale.to_s
      end


    end
  end
end