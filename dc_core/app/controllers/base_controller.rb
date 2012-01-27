# encoding: utf-8
class BaseController < ApplicationController
  
  layout proc { |controller| controller.request.xhr? ? false : 'public' }
  
  include GlobalBase
  
end