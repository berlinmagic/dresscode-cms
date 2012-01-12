# encoding: utf-8
class Dc::BaseController < ApplicationController
  
  layout proc { |controller| controller.request.xhr? ? false : 'dc' }
  
  helper :all
  
  before_filter :authorized_admin
  
  def dashboard
    
  end
  
end