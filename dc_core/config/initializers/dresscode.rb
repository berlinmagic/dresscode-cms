# encoding: utf-8
## => inspired by Spree  (  https://github.com/spree/spree  &  http://spreecommerce.com/  )  ... thanks a lot !!!
  ActiveRecord::Base.class_eval do
    include DC::Preferences
    include DC::Preferences::ModelHooks
  end

  # Initialize Core-settings
  DC::Setters::CoreSetter.init

  # Initialize Mail-settings
  DC::Setters::MailSetter.init
  
  #Rails.application.middleware.insert_after Dragonfly::Middleware, Rack::DcStaticCache, :urls => ["/images", "/App_Themes"], :duration => 42, :root => "public"
