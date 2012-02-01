# encoding: utf-8
class Dc::SettingsController < Dc::BaseController
  
  before_filter :load_dc_setting_names

  def index
    @u_aktiv = 'settings'
  end
  
  def show_config
    config = params[:config]
    @config = config.blank? ? 'core' : config
    @name = params[:name]
    # => render :template => "dc/settings/#{ @config }/#{ @name }"
    render :template => "dc/settings/show"
  end
  
  def update_config
    @name = params[:name] || params[:id]
    config = params[:config]
    @config = ( config.blank? || ( config == 'base' ) ) ? 'core' : config
    @params = params
    unless @config == 'core'
      if "DC::#{@config.classify}".constantize::Config.set(params[:preferences])
        render_config
      else
        render_config_error
      end
    else
      if DC::Config.set(params[:preferences])
        render_config
      else
        render_config_error
      end
    end
  end
  
  def render_config
    # => redirect_to "/#{ DC::Config[:pretty_namespace] }/settings/#{ @config }/#{ @name }", :notice => I18n.t('dc.preferences.updated_succesfully')
    redirect_to view_dcr_settings_path( @config, @name ), :notice => I18n.t('dc.preferences.updated_succesfully')
  end
  
  def render_config_error
    # => redirect_to "/#{ DC::Config[:pretty_namespace] }/settings/#{ @config }/#{ @name }", :notice => I18n.t('dc.preferences.update_error')
    redirect_to view_dcr_settings_path( @config, @name ), :notice => I18n.t('dc.preferences.update_error')
  end
  
  
  def load_dc_setting_names
    # => @setting_names = ["cms", "account", "kontakt", "mail", "optik", "user"]
    # => @setting_names = ["cms", "core", "account", "mail", "optik", "stylez", "user"]
    # => @setting_names = ["core", "stylez", "user", 'core_one', 'cache', 'meta', 'api']
    @config_names = %w[core stylez user]
    @core_names = %w[account site optik api cache meta mailer]
  end
  
end