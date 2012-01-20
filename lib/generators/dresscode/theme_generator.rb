require 'rails/generators'

module Dresscode
  module Generators
    class ThemeGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a new theme gem with the name you specify."
      check_class_collision
      
      

      def create_root_files
        @strange_class = "StrangeTheme#{ class_name }"
        @strange_name  = "#{ file_name.gsub(/strange_/, '') }"
        @strange_file  = "strange_theme_#{ @strange_name }"
        empty_directory "#{ @strange_file }"
        empty_directory "#{@strange_file}/public"
        template "Rakefile.tt", "#{@strange_file}/Rakefile"
        template "README.md", "#{@strange_file}/README.md"
        template "gitignore.tt", "#{@strange_file}/.gitignore"
        template "theme.gemspec.tt", "#{@strange_file}/#{@strange_file}.gemspec"
      end

      def create_config_files
        empty_directory "#{@strange_file}/config"
        template "config/routes.rb", "#{@strange_file}/config/routes.rb"
        empty_directory "#{@strange_file}/config/locales"
        template "config/locales/de.yml", "#{@strange_file}/config/locales/de.yml"
        template "config/locales/en.yml", "#{@strange_file}/config/locales/en.yml"
      end

      #def install_rake
      #  template "install.rake.tt", "#{file_name}/lib/tasks/install.rake"
      #end

      def create_app_dirs
        empty_directory "#{@strange_file}/app"
        empty_directory "#{@strange_file}/#{StrangeThemes.config.themes_dir}"
        empty_directory "#{@strange_file}/#{StrangeThemes.config.themes_dir}/#{@strange_name}"
        empty_directory "#{@strange_file}/#{StrangeThemes.config.themes_dir}/#{@strange_name}/views"
        empty_directory "#{@strange_file}/app/controllers"
        empty_directory "#{@strange_file}/app/helpers"
        empty_directory "#{@strange_file}/app/models"
        empty_directory "#{@strange_file}/app/views"
      end

      def create_lib_files
        empty_directory "#{@strange_file}/lib"
        template 'lib/theme.rb.tt', "#{@strange_file}/lib/#{@strange_file}.rb"
        template 'lib/theme_version.rb.tt', "#{@strange_file}/lib/#{@strange_file}/version.rb"
        
        template 'lib/theme_hooks.rb.tt', "#{@strange_file}/lib/#{@strange_file}_hooks.rb"
        template 'lib/modul_theme.rb.tt', "#{@strange_file}/lib/#{@strange_file}_theme.rb"
        template 'lib/theme_modul.rb.tt', "#{@strange_file}/lib/#{@strange_file}_modul.rb"
        
        template 'lib/theme__initializer.rb.tt', "#{@strange_file}/lib/theme_#{@strange_name}_initializer.rb"
        
        # => empty_directory "#{file_name}/lib/generators"
        # => empty_directory "#{file_name}/lib/generators/#{file_name}"
        # => template 'lib/install_generator.rb.tt', "#{file_name}/lib/generators/#{file_name}/install_generator.rb"
        # => template 'lib/update_generator.rb.tt', "#{file_name}/lib/generators/#{file_name}/update_generator.rb"
        # => empty_directory "#{file_name}/lib/generators/#{file_name}/templates"
        # => template 'lib/templates/create_modul.rb.tt', "#{file_name}/lib/generators/#{file_name}/templates/create_#{file_name}.rb"
        # => template 'lib/templates/update_modul.rb.tt', "#{file_name}/lib/generators/#{file_name}/templates/update_#{file_name}.rb"
        # => template 'lib/templates/seed_modul.rb.tt', "#{file_name}/lib/generators/#{file_name}/templates/seed_#{file_name}.rb"
      end


      def update_gemfile
        gem @strange_file, :path => @strange_file, :require => @strange_file
      end
      
      def create_full_theme
        if yes?("Alle relevanten Dateien in neuen Theme-Ordner spiegeln?")
          puts("StrangeSites:: Spiegle views in default-Theme view-Ordner")
          DC::FileUtilz.mirror_files( 
                File.join("#{StrangeSites::Engine.config.root}", "app", "views"), 
                File.join("#{@strange_file}/#{StrangeThemes.config.themes_dir}/#{@strange_name}", "views") 
                )
          puts("StrangeSites:: Spiegle views in default-Theme view-Ordner")
          DC::FileUtilz.mirror_files( 
                File.join("#{StrangeSites::Engine.config.root}", "public"), 
                File.join("#{@strange_file}/#{StrangeThemes.config.themes_dir}/#{@strange_name}") 
                )
          puts("StrangeCore:: Spiegle views in default-Theme view-Ordner")
          DC::FileUtilz.mirror_files( 
                File.join("#{StrangeCore::Engine.config.root}", "app", "views"), 
                File.join("#{@strange_file}/#{StrangeThemes.config.themes_dir}/#{@strange_name}", "views") 
                )
          puts("StrangeUser:: Spiegle views in default-Theme view-Ordner")
          DC::FileUtilz.mirror_files( 
                File.join("#{StrangeUser::Engine.config.root}", "app", "views"), 
                File.join("#{@strange_file}/#{StrangeThemes.config.themes_dir}/#{@strange_name}", "views") 
                )
          DC::ModuleSupport::CmsModule.modules.each do |modul|
            unless modul.core?
                copy_modul_data( modul.modul_name )
            end
          end
        end
      end
      
      def create_full_fineline_theme
        if yes?("fineline-Theme-Ordner erstellen und alle relevanten Dateien hinein spiegeln?")
          empty_directory "#{@strange_file}/#{StrangeThemes.config.themes_dir}/fineline"
          empty_directory "#{@strange_file}/#{StrangeThemes.config.themes_dir}/fineline/views"
          puts("StrangeSites:: Spiegle views in default-Theme view-Ordner")
          DC::FileUtilz.mirror_files( 
                File.join("#{StrangeSites::Engine.config.root}", "app", "views"), 
                File.join("#{@strange_file}/#{StrangeThemes.config.themes_dir}/fineline", "views") 
                )
          puts("StrangeSites:: Spiegle views in default-Theme view-Ordner")
          DC::FileUtilz.mirror_files( 
                File.join("#{StrangeSites::Engine.config.root}", "public"), 
                File.join("#{@strange_file}/#{StrangeThemes.config.themes_dir}/fineline") 
                )
          puts("StrangeCore:: Spiegle views in default-Theme view-Ordner")
          DC::FileUtilz.mirror_files( 
                File.join("#{StrangeCore::Engine.config.root}", "app", "views"), 
                File.join("#{@strange_file}/#{StrangeThemes.config.themes_dir}/fineline", "views") 
                )
          puts("StrangeUser:: Spiegle views in default-Theme view-Ordner")
          DC::FileUtilz.mirror_files( 
                File.join("#{StrangeUser::Engine.config.root}", "app", "views"), 
                File.join("#{@strange_file}/#{StrangeThemes.config.themes_dir}/fineline", "views") 
                )
          DC::ModuleSupport::CmsModule.modules.each do |modul|
            unless modul.core?
                copy_modul_fineline_data( modul.modul_name )
            end
          end
        end
      end
      
      def create_full_default_theme
        if yes?("Default-Theme-Ordner erstellen und alle relevanten Dateien hinein spiegeln?")
          empty_directory "#{@strange_file}/#{StrangeThemes.config.themes_dir}/default"
          empty_directory "#{@strange_file}/#{StrangeThemes.config.themes_dir}/default/views"
          puts("StrangeSites:: Spiegle views in default-Theme view-Ordner")
          DC::FileUtilz.mirror_files( 
                File.join("#{StrangeSites::Engine.config.root}", "app", "views"), 
                File.join("#{@strange_file}/#{StrangeThemes.config.themes_dir}/default", "views") 
                )
          puts("StrangeSites:: Spiegle views in default-Theme view-Ordner")
          DC::FileUtilz.mirror_files( 
                File.join("#{StrangeSites::Engine.config.root}", "public"), 
                File.join("#{@strange_file}/#{StrangeThemes.config.themes_dir}/default") 
                )
          puts("StrangeCore:: Spiegle views in default-Theme view-Ordner")
          DC::FileUtilz.mirror_files( 
                File.join("#{StrangeCore::Engine.config.root}", "app", "views"), 
                File.join("#{@strange_file}/#{StrangeThemes.config.themes_dir}/default", "views") 
                )
          puts("StrangeUser:: Spiegle views in default-Theme view-Ordner")
          DC::FileUtilz.mirror_files( 
                File.join("#{StrangeUser::Engine.config.root}", "app", "views"), 
                File.join("#{@strange_file}/#{StrangeThemes.config.themes_dir}/default", "views") 
                )
          DC::ModuleSupport::CmsModule.modules.each do |modul|
            unless modul.core?
                copy_modul_default_data( modul.modul_name )
            end
          end
        end
      end

      protected
      
      def copy_modul_data( modul )
        puts("#{modul.gsub(/Strange/, '')}:: Spiegle views in default-Theme view-Ordner")
        DC::FileUtilz.mirror_files( 
              File.join("#{modul.constantize::Engine.config.root}", "app", "views"), 
              File.join("#{@strange_file}/#{StrangeThemes.config.themes_dir}/#{@strange_name}", "views") 
              )
        puts("#{modul.gsub(/Strange/, '')}:: Spiegle Daten in default-Theme public-Ordner")
        DC::FileUtilz.mirror_files( 
              File.join("#{modul.constantize::Engine.config.root}", "public"), 
              File.join("#{@strange_file}/#{StrangeThemes.config.themes_dir}/#{@strange_name}")
              )
      end
      
      def copy_modul_default_data( modul )
        puts("#{modul.gsub(/Strange/, '')}:: Spiegle views in default-Theme view-Ordner")
        DC::FileUtilz.mirror_files( 
              File.join("#{modul.constantize::Engine.config.root}", "app", "views"), 
              File.join("#{@strange_file}/#{StrangeThemes.config.themes_dir}/default", "views") 
              )
        puts("#{modul.gsub(/Strange/, '')}:: Spiegle Daten in default-Theme public-Ordner")
        DC::FileUtilz.mirror_files( 
              File.join("#{modul.constantize::Engine.config.root}", "public"), 
              File.join("#{@strange_file}/#{StrangeThemes.config.themes_dir}/default")
              )
      end
      
      def copy_modul_fineline_data( modul )
        puts("#{modul.gsub(/Strange/, '')}:: Spiegle views in default-Theme view-Ordner")
        DC::FileUtilz.mirror_files( 
              File.join("#{modul.constantize::Engine.config.root}", "app", "views"), 
              File.join("#{@strange_file}/#{StrangeThemes.config.themes_dir}/fineline", "views") 
              )
        puts("#{modul.gsub(/Strange/, '')}:: Spiegle Daten in default-Theme public-Ordner")
        DC::FileUtilz.mirror_files( 
              File.join("#{modul.constantize::Engine.config.root}", "public"), 
              File.join("#{@strange_file}/#{StrangeThemes.config.themes_dir}/fineline")
              )
      end

      def current_locale
        I18n.locale.to_s
      end

      def extension_dir(join=nil)
        if join
          File.join(file_name, join)
        else
          file_name
        end
      end

    end
  end
end