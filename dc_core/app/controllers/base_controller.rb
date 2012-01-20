# encoding: utf-8
class BaseController < ApplicationController
  
  layout proc { |controller| controller.request.xhr? ? false : themed_path('public') }
  
  include GlobalBase
  
end