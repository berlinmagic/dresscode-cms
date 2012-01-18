
#require 'dc_themes_dynamic_help'
#require 'dc_themes_dynamic_modul'
require 'dc_themes_dynamic/version'
require 'dc_themes_dynamic/style_class_routes'

module DcThemesDynamic
  class Engine < Rails::Engine

      config.autoload_paths += %W(#{config.root}/lib)

      def self.activate

        Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
          Rails.env == "production" ? require(c) : load(c)
        end

      end

      config.to_prepare &method(:activate).to_proc

    end
end


