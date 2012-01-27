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
  
  def edit
    @user = User.find(params[:id])
  end
  
  def destroy
    @user = User.find( params[:id] )
    @user.destroy
    respond_to do |format|
      format.js   { render :nothing => true }
      format.html { redirect_to dcr_users_path, :notice => I18n.t('dc.users.flash_msg.user_succesfully_deleted') }
    end
  end
  
  def update
    @user = User.find( params[:id] )
    if @user.update_attributes( params[:user] )
      redirect_to( dcr_users_path, :notice => I18n.t('dc.users.flash_msg.user_succesfully_updatet') )
    else
      redirect_to( dcr_users_path, :error => I18n.t('dc.users.flash_msg.user_update_error') )
    end
  end
  
end
