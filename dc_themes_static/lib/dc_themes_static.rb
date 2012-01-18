require 'active_support/dependencies'

require "cells"

require 'dc_themes_static/config'
require 'dc_themes_static/common_methods'
require 'dc_themes_static/url_helpers'
require 'dc_themes_static/view_helpers'
require 'dc_themes_static/assets_controller'
require 'dc_themes_static/controller_methods'
require 'dc_themes_static/railtie'
require 'dc_themes_static/routes'
require 'dc_themes_static/gemed_themes'
require "dc_themes_static/version"

# => require 'strange_themes_help'
# => require 'strange_themes_modul'
# => require 'theme_default_initializer'


module DcThemesStatic
  class << self

    def config
      @config ||= DcThemesStatic::Config.new
      yield(@config) if block_given?
      @config
    end
    
    def available_themes(&block)
      ths = []
      ths = Dir.glob(File.join(config.themes_path, "*"), &block) 
      if config.gem_theme_available?
        config.gem_theme_pathes.each do |thp|
          tgs = []
          tgs = Dir.glob(File.join(thp, config.themes_dir, "*"), &block) 
          tgs.each do |tg|
            ths << tg
          end
        end
      end
      ths
    end
    alias each_theme_dir available_themes
    
    def available_theme_names
      available_themes.map {|theme| File.basename(theme.to_s) } 
    end
    
    def all_theme_hash
      ath = {}
      ths = Dir.glob(File.join(config.themes_path, "*")) 
      ths.each do |tp|
        ath["#{File.basename(tp.to_s)}"] = { "base" => "#{config.base_dir}", "theme_dir" => "#{File.join(config.base_dir, config.themes_dir)}", "theme" => "#{tp.to_s}"}
      end
      tgs = []
      tgp = []
      if config.gem_theme_available?
        config.gem_theme_pathes.each do |thp|
          xax = []
          xax = Dir.glob(File.join(thp, config.themes_dir, "*")) 
          xax.each do |axa|
            tgs << axa
            tgp << thp
          end
        end
      end
      tgs.each_with_index do |gtp, i|
        ath["#{File.basename(gtp.to_s)}"] = { "base" => "#{tgp[i].to_s}", "theme_dir" => "#{File.join(tgp[i].to_s, config.themes_dir)}", "theme" => "#{gtp.to_s}"}
      end
      ath
    end
    
    def add_themes_path_to_sass
      if DcThemesStatic.config.sass_is_available?
        each_theme_dir do |dir|
          if File.directory?(dir) # Need to get rid of the '.' and '..'

            sass_dir = "#{dir}/stylesheets/sass"
            css_dir = "#{dir}/stylesheets"

            unless already_configured_in_sass?(sass_dir)
              Sass::Plugin.add_template_location sass_dir, css_dir 
            end
          end
        end 
      else
        raise "Sass is not available. What are you trying to do?"
      end
    end
    
    def already_configured_in_sass?(sass_dir)
      Sass::Plugin.template_location_array.map(&:first).include?(sass_dir)
    end
    
  end
end
