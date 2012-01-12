# encoding: utf-8
ApplicationController.class_eval do

  before_filter :set_theme_for_app
  
  layout proc { |controller| controller.request.xhr? ? false : 'dc' }
  
  private
  
  def set_theme_for_app
    if DC::Config[:theme] && DC::Config[:theme] != ''
       theme DC::Config[:theme]
     else
       theme 'default'
     end
  end

end
