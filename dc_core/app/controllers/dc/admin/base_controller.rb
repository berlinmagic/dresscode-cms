# encoding: utf-8
class Dc::Admin::BaseController < Dc::BaseController
  
  layout proc { |controller| controller.request.xhr? ? false : 'dc' }
  
  def dashboard
    
  end
  
end