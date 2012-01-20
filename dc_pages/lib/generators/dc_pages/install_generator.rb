# encoding: utf-8
require 'rails/generators/migration'

module DcPages
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
      source_root DcPages::Engine.root
      desc "add the migrations"
      
      def build_seed_data
        Dir.glob( File.join(File.expand_path("#{DcPages::Engine.root}/db/system_data", __FILE__), "*.*") ) do |file|
          puts("DcPages:: Seed system_data")
          open("#{Rails.root}/db/seeds.rb", 'a') do |f|
            f.puts File.read( "#{DcPages::Engine.root}/db/system_data/#{File.basename(file.to_s)}"  ).to_utf
          end
        end
      end
      
      def build_sample_data
        Dir.glob( File.join(File.expand_path("#{DcPages::Engine.root}/db/sample_data", __FILE__), "*.*") ) do |file|
          puts("DcPages:: Seed sample_data")
          open("#{Rails.root}/db/sample_seeds.rb", 'a') do |f|
            f.puts File.read( "#{DcPages::Engine.root}/db/sample_data/#{File.basename(file.to_s)}" ).to_utf
          end
        end
      end
      
      def self.next_migration_number(path)
        @prev_migration_nr ? @prev_migration_nr += 1 : @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        @prev_migration_nr.to_s
      end

      def copy_migrations
        puts("Info:: erstelle Migrations")
        Dir.glob( File.join(File.expand_path("#{DcPages::Engine.root}/db/templates", __FILE__), "*.*") ) do |file|
          migration_template "#{file}", "db/migrate/#{File.basename(file.to_s)}"
        end
      end
      

    end
  end
end