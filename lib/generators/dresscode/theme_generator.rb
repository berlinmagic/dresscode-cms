require 'rails/generators'

module Dresscode
  module Generators
    class ThemeGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a new theme gem with the name you specify."
      check_class_collision
      
      def create_root_files
        @strange_class = "DcTheme#{ class_name }"
        @strange_name  = "#{ file_name.gsub(/dc_/, '') }"
        @strange_file  = "dc_theme_#{ @strange_name }"
        empty_directory "#{ @strange_file }"
        
        template "shared/gitignore.tt", "#{ @strange_file }/.gitignore"
        template "shared/Gemfile.tt", "#{ @strange_file }/Gemfile"
        template "shared/Rakefile.tt", "#{ @strange_file }/Rakefile"
        template "theme/README.md.tt", "#{ @strange_file }/README.md"
        template "theme/dc_gem.gemspec.tt", "#{ @strange_file }/#{ @strange_file }.gemspec"
      end

      def create_config_files
        empty_directory "#{ @strange_file }/config"
        # template "shared/config/routes.rb", "#{ @strange_file }/config/routes.rb" # => mostyl don´t needed in Theme
        empty_directory "#{ @strange_file }/config/locales"
        template "shared/config/locales/de.yml", "#{ @strange_file }/config/locales/de.yml"
        template "shared/config/locales/en.yml", "#{ @strange_file }/config/locales/en.yml"
      end

      #def install_rake
      #  template "install.rake.tt", "#{file_name}/lib/tasks/install.rake"
      #end

      def create_app_dirs
        empty_directory "#{@strange_file}/#{DcThemesStatic.config.themes_dir}"
        empty_directory "#{@strange_file}/#{DcThemesStatic.config.themes_dir}/#{@strange_name}"
        empty_directory "#{@strange_file}/#{DcThemesStatic.config.themes_dir}/#{@strange_name}/views"
         # => mostyl don´t needed in Themes:
        # empty_directory "#{@strange_file}/app"
        # empty_directory "#{@strange_file}/app/controllers"
        # empty_directory "#{@strange_file}/app/helpers"
        # empty_directory "#{@strange_file}/app/models"
        # empty_directory "#{@strange_file}/app/views"
      end

      def create_lib_files
        empty_directory "#{ @strange_file }/lib"
        empty_directory "#{ @strange_file }/lib/#{ @strange_file }"
        
        template 'theme/lib/dc_gem.rb.tt', "#{ @strange_file }/lib/#{ @strange_file }.rb"
        template 'theme/lib/dc_gem_module.rb.tt', "#{ @strange_file }/lib/#{ @strange_file }_module.rb"
        
        template 'shared/lib/version.rb.tt', "#{ @strange_file }/lib/#{ @strange_file }/version.rb"
        template 'shared/lib/routes.rb.tt', "#{ @strange_file }/lib/#{ @strange_file }/routes.rb"
        template 'shared/lib/dc_gem_hooks.rb.tt', "#{ @strange_file }/lib/#{ @strange_file }_hooks.rb"
        
        
        template 'theme/lib/dc_gem_theme.rb.tt', "#{ @strange_file }/lib/#{ @strange_file }_theme.rb"
        
        template 'theme/lib/dc_gem_initializer.rb.tt', "#{ @strange_file }/lib/theme_#{ file_name }_initializer.rb"
        
         # => mostyl don´t needed in Themes:
        # => empty_directory "#{ @strange_file }/lib/generators"
        # => empty_directory "#{ @strange_file}/lib/generators/#{ @strange_file }"
        # => template 'shared/lib/install_generator.rb.tt', "#{ @strange_file }/lib/generators/#{ @strange_file }/install_generator.rb"
        # => empty_directory "#{ @strange_file }/db"
        # => empty_directory "#{ @strange_file }/db/templates"
        # => empty_directory "#{ @strange_file }/db/system_data"
        # => empty_directory "#{ @strange_file }/db/sample_data"
        # => template 'shared/lib/templates/create.rb.tt', "#{ @strange_file }/db/templates/create_#{ @strange_file }.rb"
        # => template 'shared/lib/templates/seed.rb.tt', "#{ @strange_file }/db/system_data/#{ @strange_file }.rb"
        # => template 'shared/lib/templates/seed.rb.tt', "#{ @strange_file }/db/sample_data/#{ @strange_file }.rb"
      end


      def update_gemfile
        gem @strange_file, :path => @strange_file, :require => @strange_file
      end
      
      def create_full_theme
        puts("############################################################################################################")
        puts("###   Q U E S T I O N   /   F R A G E    ###################################################################")
        puts("############################################################################################################")
        puts("[en] => Mirror all views and statics in Theme? .. not needed, just copy what you need!")
        puts("[de] => alle views und daten in Theme spiegeln? .. Unnötig, kopieren Sie nur dateien die Sie ändern wollen!")
        puts("############################################################################################################")
        if yes?("Mirror all views and data in Theme?   [ y | n ]")
          
          mirror_the_full_views( @strange_name )
          
        end
      end
      
      def create_full_dresscode_theme
        puts("############################################################################################################")
        puts("###   Q U E S T I O N   /   F R A G E    ###################################################################")
        puts("############################################################################################################")
        puts("[en] => create 'dresscode' ThemeFolder and Mirror all needed views and statics (images, etc.)?")
        puts("[de] => 'dresscode' Theme-Ordner erstellen und alle relevanten views and dateien (bilder, etc.) spiegeln?")
        puts("############################################################################################################")
        if yes?("create dresscode-Theme-Folder and mirror all data?   [ y | n ]")
          empty_directory "#{@strange_file}/#{DcThemesStatic.config.themes_dir}/dresscode"
          empty_directory "#{@strange_file}/#{DcThemesStatic.config.themes_dir}/dresscode/views"
          
          mirror_the_full_views( 'dresscode' )
          
        end
      end
      
      # => def create_full_default_theme
      # =>   puts("############################################################################################################")
      # =>   puts("###   Q U E S T I O N   /   F R A G E    ###################################################################")
      # =>   puts("############################################################################################################")
      # =>   puts("[en] => create 'default' ThemeFolder and Mirror all needed views and statics (images, etc.)?")
      # =>   puts("[de] => 'default' Theme-Ordner erstellen und alle relevanten views and dateien (bilder, etc.) spiegeln?")
      # =>   puts("############################################################################################################")
      # =>   if yes?("create default-Theme-Folder and mirror all data?   [ y | n ]")
      # =>     empty_directory "#{@strange_file}/#{DcThemesStatic.config.themes_dir}/default"
      # =>     empty_directory "#{@strange_file}/#{DcThemesStatic.config.themes_dir}/default/views"
      # =>     mirror_the_full_views( 'default' )
      # =>   end
      # => end

    protected
      
      def mirror_the_full_views( da_path )
          puts("DcCore:: mirror views in ThemeFolder: #{ da_path }/views")
          DC::FileUtilz.mirror_files( 
                File.join("#{DcCore::Engine.config.root}", "app", "views"), 
                File.join("#{ @strange_file }/#{DcThemesStatic.config.themes_dir}/#{ da_path }", "views") 
                )
          puts("DcCore:: mirror statics in ThemeFolder: #{ da_path }")
          DC::FileUtilz.mirror_files( 
                File.join("#{DcCore::Engine.config.root}", "public"), 
                File.join("#{ @strange_file }/#{DcThemesStatic.config.themes_dir}/#{ da_path }") 
                )
          puts("DcPages:: mirror views in ThemeFolder: #{ da_path }/views")
          DC::FileUtilz.mirror_files( 
                File.join("#{DcPages::Engine.config.root}", "app", "views"), 
                File.join("#{ @strange_file }/#{DcThemesStatic.config.themes_dir}/#{ da_path }", "views") 
                )
          puts("DcUser:: mirror views in ThemeFolder: #{ da_path }/views")
          DC::FileUtilz.mirror_files( 
                File.join("#{DcUser::Engine.config.root}", "app", "views"), 
                File.join("#{ @strange_file }/#{DcThemesStatic.config.themes_dir}/#{ da_path }", "views") 
                )
          DC::ModuleSupport::CmsModule.modules.each do |modul|
            unless modul.core?
                mirror_the_modul_views( modul.modul_name, da_path )
            end
          end
      end
      
      def mirror_the_modul_views( modul, da_path )
        puts("#{modul.gsub(/Dc/, '')}:: mirror views in ThemeFolder: #{ da_path }/views")
        DC::FileUtilz.mirror_files( 
              File.join("#{modul.constantize::Engine.config.root}", "app", "views"), 
              File.join("#{@strange_file}/#{DcThemesStatic.config.themes_dir}/#{ da_path }", "views") 
              )
        puts("#{modul.gsub(/Dc/, '')}:: mirror statics in ThemeFolder: #{ da_path }")
        DC::FileUtilz.mirror_files( 
              File.join("#{modul.constantize::Engine.config.root}", "public"), 
              File.join("#{@strange_file}/#{DcThemesStatic.config.themes_dir}/#{ da_path }")
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