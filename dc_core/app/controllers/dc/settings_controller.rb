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
      render "dc/settings/#{@name}"
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
      @u_aktiv = @name
      render :template => "dc/settings/#{@name}_edit"
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
        if @name == 'stylez'
            @pref = params[:pref]
            @thing = params[:thing] if params[:thing]
            @area = params[:area] if params[:area]
            @group = params[:group] if params[:group]
            @preview = params[:preview] if params[:preview]
            Strangecms::Stylez::Config.set(params[:preferences])
            @ok_go = true
            expire_page	'/system/finestyle.css'
            expire_page	'/system/admin_finestyle.css'
            expire_page	'/system/editor_finestyle.css'
            flash.now[:notice] = I18n.t('strange_preferences.settings_updated')
            format.html { redirect_to "/dc/settings/#{@name}", :notice => I18n.t('strange_preferences.settings_updated') }
            format.js { render :template => "dc/settings/#{@name}_script" }
        else
          if Strangecms::Config.set(params[:preferences])
            Strangecms::Preferences::MailSettings.init if (@name == 'mail') || (@name == 'cms')
            if (@name == 'optik')
              if !!defined?"Theme#{ params[:preferences][:theme].camelize }Initializer".constantize
                "Theme#{ params[:preferences][:theme].camelize }Initializer".constantize.init
              end
              expire_page	'/system/finestyle.css'
              expire_page	'/system/admin_finestyle.css'
              expire_page	'/system/editor_finestyle.css'
              expire_page	'/system/finescript.js'
              expire_page	'/system/admin_finescript.js'
              FileUtils.touch "#{Rails.root}/tmp/restart.txt"
            end 
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
    @setting_names = ["cms", "account", "mail", "optik", "stylez", "user"]
    @aktivio = 'settings'
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
      "Strangecms::#{@prefs}".constantize::Config.set(@key => @datei.id)
    else
      Strangecms::Config.set(@key => @datei.id)
    end
    redirect_to @back_link
  end
  
end