# encoding: utf-8
require 'rails/generators'

module Dresscode
  module Generators
    class ModuleWithConfigGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a new extension gem with the name you specify."
      check_class_collision
      
      def initial_desc
        @strange_class = "Dc#{ class_name.gsub(/Dc/, '') }"
        @strange_name  = "#{ file_name.gsub(/dc_/, '') }"
        @strange_file  = "dc_#{ @strange_name }"
        puts("========================================================================================================")
        puts("-    -    -    -    -    -    -    -   D r e s s C o d e - C M S    -    -    -    -    -    -    -    -")
        puts("--------------------------------------------------------------------------------------------------------")
        puts("  .   .   .   .   .   generate Extension with Configuration:  #{ @strange_file }   .   .   .   .   .   ")
        puts("========================================================================================================")
      end

      def create_root_files
        empty_directory @strange_file
        template "shared/gitignore.tt", "#{ @strange_file }/.gitignore"
        template "shared/Gemfile.tt", "#{ @strange_file }/Gemfile"
        template "shared/Rakefile.tt", "#{ @strange_file }/Rakefile"
        template "module/README.md.tt", "#{ @strange_file }/README.md"
        template "module/dc_gem.gemspec.tt", "#{ @strange_file }/#{ @strange_file }.gemspec"
      end

      def create_config_files
        empty_directory "#{ @strange_file }/config"
        template "shared/config/routes.rb.tt", "#{ @strange_file }/config/routes.rb"
        empty_directory "#{ @strange_file }/config/locales"
        template "shared/config/locales/de.yml", "#{ @strange_file }/config/locales/de.yml"
        template "shared/config/locales/en.yml", "#{ @strange_file }/config/locales/en.yml"
      end

      def create_app_dirs
        empty_directory "#{ @strange_file }/app"
        empty_directory "#{ @strange_file }/app/controllers"
        # empty_directory "#{ @strange_file }/app/helpers"
        empty_directory "#{ @strange_file }/app/models"
        empty_directory "#{ @strange_file }/app/views"
        empty_directory "#{ @strange_file }/app/views/dc"
        empty_directory "#{ @strange_file }/app/views/dc/settings"
        empty_directory "#{ @strange_file }/app/views/dc/settings/#{ file_name }"
      end

      def create_lib_files
        empty_directory "#{ @strange_file }/lib"
        empty_directory "#{ @strange_file }/lib/#{ @strange_file }"
        empty_directory "#{ @strange_file }/lib/#{ file_name }"
        
        template 'module/lib/dc_gem_config.rb.tt', "#{ @strange_file }/lib/#{ file_name }/config.rb"
        template 'module/lib/dc_gem_wc.rb.tt', "#{ @strange_file }/lib/#{ @strange_file }.rb"
        template 'module/lib/dc_gem_wc_hooks.rb.tt', "#{ @strange_file }/lib/#{ @strange_file }_hooks.rb"
        
        template 'module/lib/dc_gem_module.rb.tt', "#{ @strange_file }/lib/#{ @strange_file }_module.rb"
        
        template 'shared/lib/version.rb.tt', "#{ @strange_file }/lib/#{ @strange_file }/version.rb"
        template 'shared/lib/routes.rb.tt', "#{ @strange_file }/lib/#{ @strange_file }/routes.rb"
        
        empty_directory "#{ @strange_file }/lib/generators"
        empty_directory "#{ @strange_file}/lib/generators/#{ @strange_file }"
        template 'shared/lib/install_generator.rb.tt', "#{ @strange_file }/lib/generators/#{ @strange_file }/install_generator.rb"
        empty_directory "#{ @strange_file }/db"
        empty_directory "#{ @strange_file }/db/templates"
        empty_directory "#{ @strange_file }/db/system_data"
        empty_directory "#{ @strange_file }/db/sample_data"
        template 'shared/lib/templates/create.rb.tt', "#{ @strange_file }/db/templates/create_#{ @strange_file }.rb"
        template 'shared/lib/templates/seed.rb.tt', "#{ @strange_file }/db/system_data/#{ @strange_file }.rb"
        template 'shared/lib/templates/seed.rb.tt', "#{ @strange_file }/db/sample_data/#{ @strange_file }.rb"
      end
      
      def create_config_model_and_views
        template 'module/app/models/gem_configuration.rb.tt', "#{ @strange_file }/app/models/#{ file_name }_configuration.rb"
        template 'module/app/views/settings/base.html.erb', "#{ @strange_file }/app/views/dc/settings/#{ file_name }/base.html.erb"
      end
      
      def end_desc
        puts("========================================================================================================")
        puts("-    -    -    -    -    -    -    -   #{ @strange_file } ready!    -    -    -    -    -    -    -    -")
        puts("========================================================================================================")
      end


      protected

      def current_locale
        I18n.locale.to_s
      end


    end
  end
end