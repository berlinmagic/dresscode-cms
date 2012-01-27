# encoding: utf-8
class Dc::SettingsController < Dc::BaseController
  
  before_filter :load_strange_setting_names

  def index
    @u_aktiv = 'settings'
  end
  
  def show
    @name = params[:name] || params[:id]
    if @setting_names.include?(@name)
      @u_aktiv = @name
      if @name == 'user'
        @owners = User.where(:group_id => 1)
      end
      if @name == 'core_one'
        render :template => "dc/settings/core"
      else
        if (@name == 'core') || (@name == 'user') || (@name == 'stylez')
          render :template => "dc/settings/show"
        else
          render :template => "dc/settings/#{ @name }"
        end
      end
    else
      flash.now[:alert] = I18n.t('strange_preferences.parameter_error')
      render :index
    end
  end
  
  def info
  end
  
  def edit
    @name = params[:name] || params[:id]
    if @setting_names.include?(@name)
      if @name == 'core_one'
        render :template => "dc/settings/core_edit"
      else
        render :template => "dc/settings/edit"
      end
    else
      flash.now[:alert] = I18n.t('strange_preferences.parameter_error')
      render :index
    end
  end
  
  def update
    @name = params[:name] || params[:id]
    @params = params
    if @setting_names.include?(@name)
      @u_aktiv = @name
      respond_to do |format|
        if (@name == 'stylez') || (@name == 'user')
          if "DC::#{@name.classify}".constantize::Config.set(params[:preferences])
            format.html { redirect_to "/dc/settings/#{@name}", :notice => I18n.t('strange_preferences.settings_updated') }
          else
            format.html { redirect_to "/dc/settings/#{@name}", :notice => I18n.t('strange_preferences.updated_error') }
          end
        else
          if DC::Config.set(params[:preferences])
            format.html { redirect_to "/dc/settings/#{@name}", :notice => I18n.t('strange_preferences.settings_updated') }
          else
            format.html { redirect_to "/dc/settings/#{@name}", :notice => I18n.t('strange_preferences.updated_error') }
          end
        end
        
        
      end
    else
      flash.now[:alert] = I18n.t('strange_preferences.parameter_error')
      render :index
    end
  end
  
  def load_strange_setting_names
    # @setting_names = ["cms", "account", "kontakt", "mail", "optik", "user"]
    # => @setting_names = ["cms", "core", "account", "mail", "optik", "stylez", "user"]
    @setting_names = ["core", "stylez", "user", 'core_one', 'cache', 'meta', 'api']
    @aktivio = 'settings'
  end
  
  def show_config
    config = params[:config]
    @config = ( config.blank? || ( config == 'base' ) ) ? 'core' : config
    @name = params[:name]
    render :template => "dc/settings/#{ @name }"
  end
  
  def new_pref_pic
    @prefs     = params[:prefs]
    @name      = params[:name]
    @key       = params[:key]
    @typ       = params[:typ]
    @back_link = params[:back_link]
    @modul     = params[:modul]
    @datei = Datei.new()
    render :template => 'admin/settings/pref_pic_form'
  end
  
  def edit_pref_pic
    @prefs     = params[:prefs]
    @name      = params[:name]
    @key       = params[:key]
    @typ       = params[:typ]
    @back_link = params[:back_link]
    @modul     = params[:modul]
    render :template => 'admin/settings/pref_pic_form'
  end
  
  def update_pref_pic
    @prefs     = params[:prefs]
    @key       = params[:key]
    @typ       = params[:typ]
    @back_link = params[:back_link]
    @datei = Datei.new( params[:datei] )
    @datei.save
    if !@prefs.blank?
      "DC::#{@prefs}".constantize::Config.set(@key => @datei.id)
    else
      DC::Config.set(@key => @datei.id)
    end
    redirect_to @back_link
  end
  
end