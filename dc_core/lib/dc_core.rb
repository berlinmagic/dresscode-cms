  require "rails/all"
  require "dresscode"
  require "dc_core"
  
  require "dc_hook_support"
  
  # => Rails Extensions:
  require "ext/array"             # => pagination for arrays
  require "ext/string"            # => to_url, to_anker, to_slash
  require "ext/file_utilz"        # => mirroring files
  require "ext/mail_reg"          # => RegEx to Check E-Mails
  require "ext/email_ar_ext"      # => ActiveRecord-Ext. Each-Email-Validator
  require "ext/email_validator"   # => email_validator = :email => true
  
  
  # => Module Support
  require 'dc/module_support/cms_module'
  require 'dc/module_support/listener'
  
  # => Preferences
  require 'dc/preferences/model_hooks'
  require 'dc/preferences/preference_definition'
  require 'dc/preference_access'
  
  # => Config-File (DC::Config[])
  require 'dc/config'
  
  
  # => Load some Helper
  require 'helper/front_base'
  require 'helper/admin_base'
  require 'helper/system_base'
  require 'helper/global_base'
  
  require 'helper/dc_styles_help'
  
  
  # => Load Core - Hooks & Module
  require 'dc_core_module'
  require 'dc_core_hooks'
  
  
  # => Load RailTie
  require 'dc_core/version'
  require 'dc_core/railtie'
  
  # look also in dc_core/config/intializers/*.rb