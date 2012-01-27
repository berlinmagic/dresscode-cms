# encoding: utf-8
class Dc::BaseController < ApplicationController
  
  layout proc { |controller| controller.request.xhr? ? false : 'dc' }
  
  include GlobalBase
  
  
  # => before_filter :authorized_admin
  before_filter :authorized_user
  
  
  def dashboard
    
  end
  
end