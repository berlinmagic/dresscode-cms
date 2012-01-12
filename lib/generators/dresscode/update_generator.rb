# encoding: utf-8
require 'rails/generators/migration'
module Strangecms
  module Generators
    class UpdateGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      include Thor::Actions
      desc "Creates a CMS basic structure."
      
      def self.next_migration_number(path)
        @prev_migration_nr ? @prev_migration_nr += 1 : @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        @prev_migration_nr.to_s
      end
      
      def initial_desc
        puts('   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *')
        puts('   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .')
        puts('   .   .   .   .   .   .   s t r a n g e C M S    system-update    .   .   .   .   .   .   .   .   .   .')
        puts('   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .')
        puts('   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *')
      end

      def update_core
        Strangecms::CmsModul::FineModul.fine_modules.each do |modul|
          if modul.updatable?
              generate("#{modul.gem_name}:update") if modul.core?
          end
        end
      end
      
      def update_fine_modules
        Strangecms::CmsModul::FineModul.fine_modules.each do |modul|
          if modul.updatable?
              generate("#{modul.gem_name}:update") unless modul.core?
          end
        end
      end
      
      def update_development_db
        if yes?("fineline - Development-DB erstellen?")
          puts("INFO: update DB-Migration")
          rake("db:migrate")
        end
      end
      
      
      def migrate_db_prod
        puts("INFO: erstelle production DB-Migration")
        # => rake("db:migrate RAILS_ENV=production")
        rake("db:migrate", :env => "production")
      end
      
      
      def end_desc
        puts('   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *')
        puts('   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .')
        puts('   .   .   .   .   .   .   .   .   .    s t r a n g e C M S    .   .   .   .   .   .   .   .   .   .   .')
        puts('   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .')
        puts('   .   .   .   .   Installation abgschlossen,  "rails s"  startet Ihr neues CMS!   .   .   .   .   .   .')
        puts('   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .')
        puts('   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *')
      end
      
      private
        
        def update_strange_modul( modul )
          if !!defined?modul.constantize::Engine
            # => Dir.glob( File.join(File.expand_path("#{ the_path( modul ) }/db/templates", __FILE__), "create*.*") ) do |file|
            # =>   puts("#{ modul }:: erstelle Migration .. (#{File.basename(file.to_s)})")
            # =>   migration_template "#{file}", "db/migrate/#{File.basename(file.to_s)}"
            # => end
            # migrate Updates
            Dir.glob( File.join(File.expand_path("#{ the_path( modul ) }/db/templates", __FILE__), "update*.*") ) do |file|
              puts("#{ modul }:: erstelle Migration update .. (#{File.basename(file.to_s)})")
              migration_template "#{file}", "db/migrate/#{File.basename(file.to_s)}"
            end
            # DB-Seed
            # => Dir.glob( File.join(File.expand_path("#{ the_path( modul ) }/db/templates", __FILE__), "system_seed*.*") ) do |file|
            # =>   if File.exist?("db/seeds.rb")
            # =>     puts("#{ modul }:: erweitere System-Seed .. (#{File.basename(file.to_s)})")
            # =>     append_to_file "#{Rails.root}/db/seeds.rb",  File.read( "#{ the_path( modul ) }/db/templates/#{File.basename(file.to_s)}" )
            # =>   else
            # =>     puts("#{ modul }:: erstelle System-Seed .. (#{File.basename(file.to_s)})")
            # =>     create_file "#{Rails.root}/db/seeds.rb",  File.read( "#{ the_path( modul ) }/db/templates/#{File.basename(file.to_s)}" )
            # =>   end
            # => end
          end
        end
        
        def the_path( modul )
          modul.constantize::Engine.config.root
        end
      
    end
  end
end