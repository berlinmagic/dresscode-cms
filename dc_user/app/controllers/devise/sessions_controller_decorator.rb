# encoding: utf-8
Devise::SessionsController.class_eval do
  
  include GlobalBase

  layout proc { |controller| controller.request.xhr? ? false : 'blank' }

end
