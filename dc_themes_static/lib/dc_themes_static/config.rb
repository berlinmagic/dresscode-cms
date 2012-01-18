module DcThemesStatic
  class Config

    attr_writer :base_dir, :themes_dir
    attr_accessor :use_sass
    
    def initialize(&block)
      @use_sass = true
      yield if block_given?
    end
    
    def base_dir
      @base_dir ||= Rails.root
    end
    
    def themes_dir
      @themes_dir ||= "App_Themes"
    end
    
    def themes_path
      File.join(base_dir, themes_dir)
    end
    
    def clear
      @base_dir = nil
      @themes_dir = nil
    end

    def use_sass?
      @use_sass and sass_is_available?
    end

    def sass_is_available?
      !!defined?Sass::Plugin
    end
    
    def gem_theme_available?
      @xx = ''
      # => Rails::Application.railties.engines.each do |key|
      # =>   @xx = 'Yeah' if key.class.to_s.split('::').first.match(/DcTheme*/)
      # => end
      DcThemesStatic::GemedThemes::ThemeListener.subclasses.each do |theme_class|
        @xx = 'Yeah'
      end
      true if @xx == 'Yeah'
    end
    
    def gem_theme_pathes
      @theme_paths = []
      # => Rails::Application.railties.engines.each do |key|
      # =>   if key.class.to_s.split('::').first.match(/DcTheme*/)
      # =>     @theme_paths << "#{key.config.root}"
      # =>   end
      # => end
      DcThemesStatic::GemedThemes::ThemeListener.subclasses.each do |theme_class|
        @theme_paths << "#{theme_class.to_s.gsub(/Theme$/, '').classify.constantize::Engine.config.root}"
      end
      return @theme_paths
    end
    
    
  end  
end