# encoding: utf-8
ApplicationController.class_eval do

  before_filter :set_theme_for_app
  
  include GlobalBase
  
  layout proc { |controller| controller.request.xhr? ? false : themed_path('dc') }
  
  private
  
  def set_theme_for_app
    if DC::Config[:theme] && (DC::Config[:theme] != '') && DcThemesStatic.available_theme_names.include?( DC::Config[:theme] )
       theme DC::Config[:theme]
     else
       theme 'default'
     end
  end

end
