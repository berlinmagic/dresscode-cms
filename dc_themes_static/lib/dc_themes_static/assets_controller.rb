require "action_controller/metal"

module DcThemesStatic
  class AssetsController < ActionController::Base
    
    include DcThemesStatic::CommonMethods
    include DcThemesStatic::UrlHelpers
    
    caches_page :stylesheets
    caches_page :javascripts
    caches_page :images
    
    def stylesheets
      render_asset asset_path_for(params[:asset], 'stylesheets', params[:theme]), defaulft_asset_path_for(params[:asset], 'stylesheets'), app_asset_path_for(params[:asset], 'stylesheets'), mime_type_from(params[:asset])
    end
    
    def javascripts
      render_asset asset_path_for(params[:asset], 'javascripts', params[:theme]), defaulft_asset_path_for(params[:asset], 'javascripts'), app_asset_path_for(params[:asset], 'javascripts'), mime_type_from(params[:asset])  
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
      #render_app_asset app_asset_path_for(params[:asset], 'javascripts'), mime_type_from(params[:asset])
      if params[:InstanceName]
        # => render request.host+request.fullpath.to_s
        send_file request.fullpath
        # => send_data File.read(Rails.root+'/public/'+request.fullpath), :disposition => 'inline', :type => mime_type
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
        if params[:InstanceName]
          render :template => Rails.root+'/public/'+request.fullpath.to_s
          # => send_file request.fullpath, :type => mime_type.to_s
          # => send_data File.read(Rails.root+'/public/'+request.fullpath), :disposition => 'inline', :type => mime_type
        else
          send_file asset, :type => mime_type.to_s, :x_sendfile => true
          # => send_data File.read(asset), :disposition => 'inline', :type => mime_type
        end
      else
        render :text => 'not found', :status => 404
      end
    end
    
    def render_asset(asset, default, app, mime_type)
      if File.exists?(asset)
        send_file asset, :type => mime_type.to_s, :x_sendfile => true
        # => send_data File.read(asset), :disposition => 'inline', :type => mime_type
      elsif File.exists?(default)
        send_file default, :type => mime_type.to_s, :x_sendfile => true
        # => send_data File.read(default), :disposition => 'inline', :type => mime_type
      elsif File.exists?(app)
        send_file app, :type => mime_type.to_s, :x_sendfile => true
        # => send_data File.read(app), :disposition => 'inline', :type => mime_type
      else
        render :text => 'not found', :status => 404
      end
    end
    
    def render_this_asset(asset, default, app, mime_type)
      if File.exists?(asset)
        if params[:InstanceName]
          render :template => Rails.root+'/public/'+request.fullpath.to_s
        else
          send_file asset, :type => mime_type.to_s, :x_sendfile => true
        end
      elsif File.exists?(default)
        if params[:InstanceName]
          render :template => Rails.root+'/public/'+request.fullpath.to_s
        else
          send_file default, :type => mime_type.to_s, :x_sendfile => true
        end
      elsif File.exists?(app)
        if params[:InstanceName]
          render :template => Rails.root+'/public/'+request.fullpath.to_s
        else
          send_file app, :type => mime_type.to_s, :x_sendfile => true
        end
      else
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
  end
end