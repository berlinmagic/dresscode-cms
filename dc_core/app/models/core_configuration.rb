# encoding: utf-8
## => inspired by Spree  (  https://github.com/spree/spree  &  http://spreecommerce.com/  )  ... thanks a lot !!!
class CoreConfiguration < Configuration
  
  # => Core-Constants
  CORE_SETS = %w[account site optik api cache meta mailer]
  
  
# ####################################################################################################
  ### ===   CMS options   ============================================= ###
  preference :site_name,          :string,      :default => 'DressCode-CMS'
  preference :site_url,           :string,      :default => 'trendgegner.de'
  # Use Yui-Compressor
  preference :compress_stylez,    :boolean,     :default => false
  preference :compress_scriptz,   :boolean,     :default => false
  # BackUp-Settings
  preference :make_backups,       :boolean,     :default => true
  preference :show_backups,       :boolean,     :default => false
  # Theme
  THEME_TYPES = %w[static dynamic]
  preference :theme,              :string,      :default => 'default'
  preference :theme_type,         :string,      :default => 'static'  # => dynamic | static ... define the theme-engine
  # pretty namespace (use /var/ insted of /dc/)
  preference :pretty_namespace,   :string,      :default => 'cms'
  preference :dc_background,      :string,      :default => 'grass_blades'
  # Safety / Login-Strategy
  preference :invite_only_site,   :boolean,     :default => 'false'
  
  
  preference :show_form_text,     :boolean,     :default => 'false'   # => Show field names in Forms ?
  
  DC_BACKGROUNDS = %w[aqua_blue aqua_blue1 aqua_blue2 aqua_blue3 aurora fall_leaves grass_blades horizon iceberg redwoods rings snowy_hills stripes summer_leaves tahoe water]
  ### =================================================================================== ###
  
  
# ####################################################################################################
  ### ===   Title options   ============================================= ###
  preference :always_put_site_name_in_title,  :boolean,     :default => true
  preference :put_site_name_bevore_title,     :boolean,     :default => false
  preference :title_seperator,                :string,      :default => ' | '
  ### =================================================================================== ###
  
  
# ####################################################################################################
  ### ===   Breadcrumps options   ============================================= ###
  BREADCRUMPS               =   %w[verlauf position]
  preference :show_breadcrumps,   :boolean,     :default => false
  preference :breadcrump_style,   :string,      :default => BREADCRUMPS[1]
  preference :breadcrump_size,    :integer,     :default => 10
  ### =================================================================================== ###
  
  
# ####################################################################################################
  ### ===   View options   ============================================= ###
  # Optional-Pages
  preference :show_sitemap,       :boolean,     :default => true
  preference :show_dashboard,     :boolean,     :default => true
  # View Flash-Messages for x seconds
  preference :show_flash_for,     :integer,     :default => 3
  # Logo-Pic´s ???
  preference :logo,               :string,      :default => '/images/logo.png'
  preference :admin_logo,         :string,      :default => "/images/backend_logo.png"
  preference :logo_datei,         :integer
  preference :use_logo_datei,     :boolean,     :default => false
  # Default-Pagination
  preference :per_page,           :integer,     :default => 9
  # Help-Settings
  preference :show_help,          :boolean,     :default => true
  ### =================================================================================== ###
  
  
# ####################################################################################################
  ### ===   Personalisation   ============================================= ###
  # => Owner-Settings
  OWNER_TYPES = %w[company private]
  preference :owner_type,         :string,      :default => 'company'
  preference :owner_name,         :string,      :default => 'Name'
  preference :owner_firstname,    :string,      :default => 'Firstname'
  preference :owner_street,       :string,      :default => 'Street'
  preference :owner_city,         :string,      :default => 'City'
  preference :owner_zip,          :string,      :default => 'Zip'
  preference :owner_country,      :string,      :default => 'Country'
  preference :owner_fon,          :string,      :default => 'Fon'
  preference :owner_fax,          :string,      :default => 'Fax'
  preference :owner_mobile,       :string,      :default => 'Mobile'
  # => Company-Settings
  preference :company,            :string,      :default => 'Company'
  preference :company_type,       :string,      :default => 'GmbH'
  preference :company_street,     :string,      :default => 'Street'
  preference :company_city,       :string,      :default => 'City'
  preference :company_zip,        :string,      :default => 'Zip'
  preference :company_country,    :string,      :default => 'Country'
  preference :company_fon,        :string,      :default => 'Fon'
  preference :company_fax,        :string,      :default => 'Fax'
  preference :company_mail,       :string,      :default => 'info@company.com'
  preference :tax_number,         :string,      :default => 'XXX'
  preference :law_state,          :string,      :default => 'Deutschland'
  ### =================================================================================== ###
  
  
# ####################################################################################################
  ### ===   Localization   ============================================= ###
  preference :allow_locale_switching,   :boolean, :default => false
  preference :default_locale,           :string, :default => 'de'
  preference :current_locale,           :string, :default => 'de'
  # => TimeZone
  preference :time_zone,          :string,      :default => 'Berlin'
  ### =================================================================================== ###
  
  
# ####################################################################################################
  ### ===   Meta-Data   ============================================= ###
  # => SEO-Defaults
  preference :meta_keywords,      :string,      :default => "dresscode, CMS, rails3, rails, ruby, berlin"
  preference :meta_description,   :string,      :default => "DressCode-CMS great new cms based on ruby on rails"
  preference :meta_author,        :string,      :default => "orangenwerk"
  preference :meta_app,           :string,      :default => "DressCode-CMS"
  preference :meta_generator,     :string,      :default => "DressCode-CMS"
  preference :meta_publisher,     :string,      :default => "DressCode-CMS"
  preference :meta_creator,       :string,      :default => "DressCode-CMS"
  ### =================================================================================== ###
  
  
# ####################################################################################################
  ### ===   A P I s  ============================================= ###
  # => Google-Api-Key´s
  preference :analytics_key,      :string,      :default => "UA-XXXXX-X"
  preference :g_maps_key,         :string,      :default => "UA-XXXXX-X"
  # => Facebook-Api-Key
  preference :facebook_app_id,    :string,      :default => "UA-XXXXX-X"
  ### =================================================================================== ###
  
  
# ####################################################################################################
  ### ===   Mail-Server   ============================================= ###
  MAIL_AUTH                 =   ['none', 'plain', 'login', 'cram_md5']  # => depreacated, but maybe in use!
  MAIL_AUTH_TYPES           =   ['none', 'plain', 'login', 'cram_md5']
  SECURE_CONNECTION_TYPES   =   ['None','SSL','TLS']
  preference :enable_mail_delivery,   :boolean,   :default => true
  preference :mail_port,              :integer,   :default => 25
  preference :mail_auth_type,         :string,    :default => MAIL_AUTH_TYPES[1]
  preference :secure_connection_type, :string,    :default => SECURE_CONNECTION_TYPES[0]
  preference :mail_host,              :string,    :default => 'mail.kundenportal.railshoster.de'
  preference :mail_domain,            :string,    :default => 'orangenwerk.com'
  preference :smtp_username,          :string,    :default => 'seite@orangenwerk.com'
  preference :smtp_password,          :string,    :default => 'mHN$yrYLNnNPB'
  preference :mails_from,             :string,    :default => 'dresscode@orangenwerk.com'
  preference :mails_to,               :string,    :default => 'dresscode@orangenwerk.com'
  preference :mail_bcc,               :string,    :default => ''
  ### =================================================================================== ###
  
  
# ####################################################################################################
  ### ===   Cache options  ============================================= ###
  CACHE_TYPES  =  ['none', 'page_cache', 'header_cache']
  SYSTEM_MODS  =  ['development', 'production']
  preference :cache_method,       :string,      :default => CACHE_TYPES[0]  # => maybe depreacated !
  preference :varnish_enabled,    :boolean,     :default => false
  preference :etags_enabled,      :boolean,     :default => false
  preference :cache_statics,      :boolean,     :default => false
  # Cache Times
  preference :editor_ttl,         :integer,     :default => 31536000 # => 1 jear
  preference :stylez_ttl,         :integer,     :default => 3600 # => 1 our
  preference :scriptz_ttl,        :integer,     :default => 3600 # => 1 our
  preference :statics_ttl,        :integer,     :default => 604800 # => 1 week
  preference :library_ttl,        :integer,     :default => 604800 # => 1 week
  preference :pages_ttl,          :integer,     :default => 3600 # => 1 our
  preference :dynamic_ttl,        :integer,     :default => 300 # => 5 minutes
  # Dev-Mod & Times
  preference :production_mode,    :boolean,     :default => false
  preference :dev_mode_ttl,       :integer,     :default => 42
  # Freshness - Timestamps
  preference :editor_fresh,       :string,      :default => 'version: 0.0.1'
  preference :stylez_fresh,       :string,      :default => 'version: 0.0.1'
  preference :scriptz_fresh,      :string,      :default => 'version: 0.0.1'
  preference :statics_fresh,      :string,      :default => 'version: 0.0.1'
  preference :library_fresh,      :string,      :default => 'version: 0.0.1'
  preference :pages_fresh,        :string,      :default => 'version: 0.0.1'
  preference :dynamic_fresh,      :string,      :default => 'version: 0.0.1'
  
  ##### new ( 2012/02/02 )
  # Cache-Methods per Action
  preference :editor_cache_method,    :string,      :default => CACHE_TYPES[1]
  preference :stylez_cache_method,     :string,      :default => CACHE_TYPES[0]
  preference :scriptz_cache_method,    :string,      :default => CACHE_TYPES[0]
  preference :library_cache_method,   :string,      :default => CACHE_TYPES[0]
  preference :pages_cache_method,      :string,      :default => CACHE_TYPES[0]
  preference :dynamic_cache_method,   :string,      :default => CACHE_TYPES[0]
  # etags per Action
  preference :editor_etags,           :boolean,     :default => false
  preference :stylez_etags,            :boolean,     :default => false
  preference :scriptz_etags,           :boolean,     :default => false
  preference :library_etags,          :boolean,     :default => false
  preference :pages_etags,             :boolean,     :default => false
  preference :dynamic_etags,          :boolean,     :default => false
  ### =================================================================================== ###
  
  
end
