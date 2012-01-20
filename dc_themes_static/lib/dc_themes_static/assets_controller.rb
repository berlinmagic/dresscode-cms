require "action_controller/metal"

module DcThemesStatic
  class AssetsController < ActionController::Base
    
    include DcThemesStatic::CommonMethods
    include DcThemesStatic::UrlHelpers
    
    # => caches_page :stylesheets
    # => caches_page :javascripts
    # => caches_page :images
    
    def stylesheets
      render_asset( 
          asset_path_for(params[:asset], 'stylesheets', params[:theme]),
          defaulft_asset_path_for(params[:asset], 'stylesheets'),
          app_asset_path_for(params[:asset], 'stylesheets'), mime_type_from(params[:asset])
          )
    end
    
    def javascripts
      render_asset( 
          asset_path_for(params[:asset], 'javascripts', params[:theme]),
          defaulft_asset_path_for(params[:asset], 'javascripts'),
          app_asset_path_for(params[:asset], 'javascripts'), mime_type_from(params[:asset])
          )
    end
    
    def images
      render_this_asset(
            asset_path_for( params[:asset], 'images', params[:theme] ), 
            defaulft_asset_path_for( params[:asset], 'images' ), 
            app_asset_path_for( params[:asset], 'images' ), 
            mime_type_from( params[:asset] )
            )  
    end
    
    # =>  NEW:    safes Production-Bild-Error
    def app_images
      render_app_asset app_asset_path_for(params[:asset], 'images'), mime_type_from(params[:asset])
    end
    
    def app_stylesheets
      render_app_asset app_asset_path_for(params[:asset], 'stylesheets'), mime_type_from(params[:asset])
    end
    
    def app_javascript
      # check if request comes from fck-editor
      if params[:InstanceName]
        send_file request.fullpath
      else
        send_file params[:asset], :type => mime_type.to_s
        # => send_data File.read(asset), :disposition => 'inline', :type => mime_type
      end
    end
    
  private
  
    def asset_path_for(asset_url, asset_prefix, theme='default')
      File.join(DcThemesStatic.all_theme_hash[theme]['theme'].to_s, asset_prefix, asset_url)
    end
    
    def defaulft_asset_path_for(asset_url, asset_prefix)
      File.join(theme_path_for('default'), asset_prefix, params[:asset])
    end
    
    def app_asset_path_for(asset_url, asset_prefix)
      File.join(Rails.root, 'public', asset_prefix, params[:asset])
    end
    
    def extract_filename_and_extension_from(asset)
      extension = File.extname(asset)
      filename = params[:asset].gsub(extension, '')
      return filename, extension[1..-1]
    end
    
    # =>  NEW:    safes Production-Bild-Error
    def render_app_asset(asset, mime_type)
      if File.exists?(asset)
        send_with_instanz_check(asset, mime_type.to_s)
      else
        render :text => 'not found', :status => 404
      end
    end
    
    def render_asset(asset, default, app, mime_type)
      if File.exists?(asset)
        send_the_theme_file(asset, mime_type)
      elsif File.exists?(default)
        send_the_theme_file(default, mime_type)
      elsif File.exists?(app)
        send_the_theme_file(app, mime_type)
      else
        logger.info asset + "  .. not found !!!"
        logger.info default + "  .. not found !!!"
        logger.info app + "  .. not found !!!"
        render :text => 'not found', :status => 404
      end
    end
    
    def render_this_asset(asset, default, app, mime_type)
      if File.exists?(asset)
        send_with_instanz_check(asset, mime_type.to_s)
      elsif File.exists?(default)
        send_with_instanz_check(default, mime_type.to_s)
      elsif File.exists?(app)
        send_with_instanz_check(app, mime_type.to_s)
      else
        logger.info asset + "  .. not found !!!"
        logger.info default + "  .. not found !!!"
        logger.info app + "  .. not found !!!"
        render :text => 'not found', :status => 404
      end
    end
  
    def mime_type_from(asset_path)
      extension = extract_filename_and_extension_from(asset_path).last
      if extension == 'css'
        "text/css"
      elsif extension == 'js'
        'text/javascript'
      elsif extension == 'html'
        'text/html'
      else
        "image/#{extension}"
      end
    end
    
    def send_with_instanz_check(file, mime_type)
      if params[:InstanceName]
        render :template => Rails.root+'/public/'+request.fullpath.to_s
      else
        send_the_theme_file(file, mime_type)
      end
    end
    
    def send_the_theme_file(file, mime_type)
      ### Sends the file, header will be overiden by DcStaticCache
      respond_with_etag( [ file, params[:theme] ] ) do
        send_file(    file, 
                      :type => mime_type.to_s, 
                      :x_sendfile => true 
                  )
      end
      # => send_data File.read(app), :disposition => 'inline', :type => mime_type
      # => send_file request.fullpath, :type => mime_type.to_s
    end
    
  end
end