module DcStaticthemes
  module ViewHelpers

    extend ActiveSupport::Concern

    included do
      include DcStaticthemes::CommonMethods
    end
    module InstanceMethods
      def current_theme_stylesheet_path(asset)
        base_theme_stylesheet_path(:theme => self.theme_name, :asset => "#{asset}.css")
      end
      def current_theme_javascript_path(asset)
        base_theme_javascript_path(:theme => self.theme_name, :asset => "#{asset}.js")
      end
      def current_theme_image_path(asset)
        base_theme_image_path(:theme => self.theme_name, :asset => asset)
      end

      def theme_stylesheet_path(asset, new_theme_name = DC::Config[:theme].to_s)
        base_theme_stylesheet_path(:theme => new_theme_name, :asset => "#{asset}.css")
      end

      def theme_javascript_path(asset, new_theme_name = DC::Config[:theme].to_s)
        base_theme_javascript_path(:theme => new_theme_name, :asset => "#{asset}.js")
      end

      def theme_image_path(asset, theme_name=DC::Config[:theme].to_s)
        if File.exists?( File.join(DcStaticthemes.all_theme_hash[theme_name]['theme'], 'images', asset) )
          "/#{DcStaticthemes.config.themes_dir}/#{theme_name}/images/#{ asset }"
        elsif File.exists?( File.join(DcStaticthemes.all_theme_hash['default']['theme'], 'images', asset) )
          "/#{DcStaticthemes.config.themes_dir}/default/images/#{ asset }"
        elsif File.exists?( File.join("#{Rails.root}", 'images', asset) )
          "/images/#{ asset }"
        end
      end
      
      def theme_image_tag(source, options = {})
        image_tag(theme_image_path(source), options)
      end

      def theme_javascript_include_tag(*files)
        files.collect! {|file| theme_javascript_path(file) }
        javascript_include_tag *files
      end

      def theme_stylesheet_link_tag(*files)
        options = files.extract_options!
        files.collect! {|file| theme_stylesheet_path(file) }
        files << options
        stylesheet_link_tag(*files)
      end
    end
  end
end

ActiveSupport.on_load(:action_view) { include DcStaticthemes::ViewHelpers }
