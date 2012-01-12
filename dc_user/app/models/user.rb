# encoding: utf-8
class User < ActiveRecord::Base
  
  CREW_ROLES = %w[user author moderator admin owner banned]
  
  USER_TYPIES = %w[herr frau]

  scope :standard, :conditions => {:evil_master => false, :site_admin => false}, :order => 'created_at DESC'
  scope :no_master, :conditions => {:evil_master => false}, :order => 'created_at DESC'
  
  belongs_to  :group
  
  has_many :rights,           :dependent => :destroy
  has_many :right_modules,    :through => :rights
  
  
  # Include default devise modules. Others available are:
  devise      :invitable,     :database_authenticatable,    :registerable,    :recoverable,     :rememberable,    :trackable,     
              :validatable,   :token_authenticatable,       :confirmable,     :lockable,        :timeoutable
  
  
  image_accessor      :image
  validates_property  :mime_type, :of => :image, :in => %w(image/jpeg image/png image/gif)
  
  
  # Setup accessible (or protected) attributes for your model
  #attr_accessible     :salutation,      :first_name,              :last_name,       :email,       :nick_name,
  #                    :password,        :password_confirmation,   :remember_me,     :dc_id,
  #                    :evil_master,     :site_admin
  
  #attr_protected      :evil_master,     :site_admin
  

end
