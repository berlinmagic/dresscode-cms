# encoding: utf-8
## => inspired by Spree  (  https://github.com/spree/spree  &  http://spreecommerce.com/  )  ... thanks a lot !!!
class CoreConfiguration < Configuration
  
  # => Core-Constants
  MAIL_AUTH                 =   ['none', 'plain', 'login', 'cram_md5']
  SECURE_CONNECTION_TYPES   =   ['None','SSL','TLS']
  BREADCRUMPS               =   %w[verlauf position]

  preference :site_name,          :string,      :default => 'DressCode-CMS'
  preference :site_url,           :string,      :default => 'dressedcode.com'
  
  # => Title-Settings
  preference :always_put_site_name_in_title,  :boolean,     :default => false
  preference :put_site_name_bevore_title,     :boolean,     :default => false
  preference :title_seperator,                :string,      :default => ' | '
  
  # => Help-Settings
  preference :show_help,          :boolean,     :default => true
  
  # => Use Yui-Compressor
  preference :compress_stylez,    :boolean,     :default => false
  preference :compress_scriptz,   :boolean,     :default => false
  
  # => Optional-Pages
  preference :show_sitemap,       :boolean,     :default => true
  preference :show_dashboard,     :boolean,     :default => true
  
  # => BackUp-Settings
  preference :make_backups,       :boolean,     :default => true
  preference :show_backups,       :boolean,     :default => false
  
  # => Breadcrumps-Settings
  preference :show_breadcrumps,   :boolean,     :default => true
  preference :breadcrump_style,   :string,      :default => BREADCRUMPS[1]
  preference :breadcrump_size,    :integer,     :default => 10
  
  # => View-Time for Flash-Messages
  preference :show_flash_for,     :integer,     :default => 3
  
  # => Show SiteName (as Headline) => depreacated
  preference :show_site_name,     :boolean,     :default => true
  
  # => Owner-Settings
  preference :owner_name,         :string,      :default => 'Name'
  preference :owner_firstname,    :string,      :default => 'Vorname'
  preference :owner_street,       :string,      :default => 'Strasse'
  preference :owner_city,         :string,      :default => 'Stadt'
  preference :owner_zip,          :string,      :default => 'Plz'
  preference :owner_country,      :string,      :default => 'Land'
  preference :owner_fon,          :string,      :default => 'Telefon'
  preference :owner_fax,          :string,      :default => 'Fax'
  preference :owner_mobile,       :string,      :default => 'Mobil-Nummer'
  # => Company-Settings
  preference :company,            :string,      :default => 'Firma'
  preference :company_type,       :string,      :default => 'GmbH'
  preference :company_street,     :string,      :default => 'Strasse'
  preference :company_city,       :string,      :default => 'Stadt'
  preference :company_zip,        :string,      :default => 'Plz'
  preference :company_country,    :string,      :default => 'Land'
  preference :company_fon,        :string,      :default => 'Telefon'
  preference :company_fax,        :string,      :default => 'Fax'
  preference :tax_number,         :string,      :default => 'XXX'
  preference :law_state,          :string,      :default => 'Deutschland'
  
  
  # => Locale
  preference :allow_locale_switching,   :boolean, :default => false
  preference :default_locale,           :string, :default => 'de'
  preference :current_locale,           :string, :default => 'de'
  
  # => TimeZone
  preference :time_zone,          :string,      :default => 'Berlin'
  
  # => Pic´s ???
  preference :logo,               :string,      :default => '/images/logo.png'
  preference :admin_logo,         :string,      :default => "/images/backend_logo.png"
  preference :logo_datei,         :integer
  preference :use_logo_datei,     :boolean,     :default => false
  
  # => Default-Pagination
  preference :per_page,           :integer,     :default => 9
  
  # => Theme
  preference :theme,              :string,      :default => 'default'
  
  # => Safety / Login-Strategy
  preference :invite_only_site,   :boolean,     :default => 'false'
  
  # => SEO-Defaults
  preference :meta_keywords,      :string,      :default => "dresscode, CMS, rails3, rails, ruby, berlin, orangenwerk"
  preference :meta_description,   :string,      :default => "DressCode-CMS great new cms based on ruby on rails develloped in berlin"
  preference :meta_author,        :string,      :default => "orangenwerk"
  preference :meta_app,           :string,      :default => "DressCode-CMS"
  preference :meta_generator,     :string,      :default => "DressCode-CMS"
  
  preference :meta_publisher,     :string,      :default => "DressCode-CMS"
  preference :meta_creator,       :string,      :default => "DressCode-CMS"
  
  
  # => Google-Api-Key´s
  preference :analytics_key,      :string,      :default => "UA-XXXXX-X"
  preference :g_maps_key,         :string,      :default => "UA-XXXXX-X"
  
  # => Facebook-Api-Key
  preference :facebook_app_id,    :string,      :default => "UA-XXXXX-X"
  
  
  # => MAIL-Server
  preference :enable_mail_delivery,   :boolean,   :default => true
  preference :mail_port,              :integer,   :default => 25
  preference :mail_auth_type,         :string,    :default => MAIL_AUTH[1]
  preference :secure_connection_type, :string,    :default => SECURE_CONNECTION_TYPES[0]
  preference :mail_host,              :string,    :default => 'mail.kundenportal.railshoster.de'
  preference :mail_domain,            :string,    :default => 'orangenwerk.com'
  preference :smtp_username,          :string,    :default => 'seite@orangenwerk.com'
  preference :smtp_password,          :string,    :default => 'mHN$yrYLNnNPB'
  # => Mail-Addresses
  preference :mails_from,             :string,    :default => 'dresscode@orangenwerk.com'
  preference :mails_to,               :string,    :default => 'dresscode@orangenwerk.com'
  preference :mail_bcc,               :string,    :default => ''
  

end
