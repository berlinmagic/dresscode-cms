# encoding: utf-8
class Dc::UsersController < Dc::BaseController

  def index
    if current_user.evil_master
      @users = User.all
    elsif current_user.site_admin
      @users = User.no_master
    else 
     @users = User.standard
    end
  end
  
  
  def show
    @user = User.find(params[:id])
  end

end
