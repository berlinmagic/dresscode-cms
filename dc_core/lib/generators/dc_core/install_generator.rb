# encoding: utf-8
require 'rails/generators/migration'

module DcCore
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
      source_root DcCore::Engine.root
      desc "add the migrations"
      
      def build_seed_data
        Dir.glob( File.join(File.expand_path("#{DcCore::Engine.root}/db/system_data", __FILE__), "*.*") ) do |file|
          puts("DcCore:: Seed system_data")
          open("#{Rails.root}/db/seeds.rb", 'a') do |f|
            f.puts File.read( "#{DcCore::Engine.root}/db/system_data/#{File.basename(file.to_s)}"  ).to_utf
          end
        end
      end
      
      def build_sample_data
        Dir.glob( File.join(File.expand_path("#{DcCore::Engine.root}/db/sample_data", __FILE__), "*.*") ) do |file|
          puts("DcCore:: Seed sample_data")
          open("#{Rails.root}/db/sample_seeds.rb", 'a') do |f|
            f.puts File.read( "#{DcCore::Engine.root}/db/sample_data/#{File.basename(file.to_s)}" ).to_utf
          end
        end
      end
      
      def strange_mirror_assets
        source = File.join("#{ DcCore::Engine.root }", 'public')
        destination = File.join(Rails.root, 'public')
        puts("DcCore:: Spiegle Daten in public-Ordner")
        DC::FileUtilz.mirror_files(source, destination)
      end

      def self.next_migration_number(path)
        @prev_migration_nr ? @prev_migration_nr += 1 : @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        @prev_migration_nr.to_s
      end

      def copy_migrations
        puts("Core:: erstelle Migrations")
        Dir.glob( File.join(File.expand_path("#{DcCore::Engine.root}/db/templates", __FILE__), "*.*") ) do |file|
          migration_template "#{file}", "db/migrate/#{File.basename(file.to_s)}"
        end
      end

    end
  end
end