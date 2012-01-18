# encoding: utf-8
ApplicationController.class_eval do
  
  include GlobalBase
  
  layout proc { |controller| controller.request.xhr? ? false : 'dc' }
  
  helper :all
  
end
