# encoding: utf-8
class User < ActiveRecord::Base
  
  # =====> C O N S T A N T S <======================================================== #
  USER_TYPIES = %w[herr frau]
  
  
  # =====> S C O P E S <======================================================== #
  scope :standard, where( :evil_master => false, :site_admin => false )
  scope :no_master, where( :evil_master => false )
  default_scope :order => 'created_at DESC'
  
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  belongs_to  :group
  
  has_many :rights,           :dependent => :destroy
  has_many :right_modules,    :through => :rights
  
  
  # =====>   D E V I S E   <======================================================== #
  devise      :invitable,     :database_authenticatable,    :registerable,    :recoverable,     :rememberable,    :trackable,     
              :validatable,   :token_authenticatable,       :confirmable,     :lockable,        :timeoutable
  
  
  # =====>   D R A G O N F L Y   <======================================================== #
  image_accessor      :image
  # => validates_property  :mime_type, :of => :image, :in => %w(image/jpeg image/png image/gif)
  
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible     :salutation,      :first_name,              :last_name,       :email,       :nick_name,
                      :password,        :password_confirmation,   :remember_me,     :dc_id,
                      :evil_master,     :site_admin,              :group_id
  #attr_protected      :evil_master,     :site_admin
  
  
  # =====> V A L I D A T I O N <======================================================== #
  validates_presence_of    :first_name, :on => :create, :message => I18n.t("Account_first_name_blank")
  validates_presence_of    :last_name, :on => :create, :message => I18n.t("Account_last_name_blank")
  validates_uniqueness_of  :email, :case_sensitive => false
  validates_uniqueness_of  :dc_id, :case_sensitive => false
  validates_uniqueness_of  :nick_name, :case_sensitive => false
  
  
  # =====> F I L T E R <======================================================== #
  before_validation :check_da_fields
  
  
private
  
  def check_da_fields
    unless !self.nick_name.blank?
      record = true
      while record
        random = "#{ self.first_name }-#{Array.new(3){rand(9)}.join}"
        record = User.where( :nick_name => random ).count > 0 ? true : false
      end
      self.first_name = random
    end
    unless !self.dc_id.blank?
      record = true
      while record
        random = "DC-User#{Array.new(9){rand(9)}.join}"
        record = User.where( :dc_id => random ).count > 0 ? true : false
      end
      self.dc_id = random
    end
  end

end
