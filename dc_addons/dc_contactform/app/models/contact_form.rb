# encoding: utf-8
class ContactForm < ActiveRecord::Base
  
  MAIL_TYPES = ['mail_in', 'mail_out', 'mail_unread', 'mail_readed']
  
  scope :mail_in, where( :answer_for => nil )
  scope :mail_out, where( :answer_for != nil )
  scope :mail_unread, where( :unread => true )
  scope :mail_readed, where( :unread => false )
  
  #   default_scope :order => "created_at DESC"
  
  validates :email, :presence => true, 
                    :length => {:maximum => 254},  # => :length => {:minimum => 3, :maximum => 254}
                    :email => true
                    
  validates :mail_content,  :presence => true, 
                            :length => {:minimum => 3, :maximum => 5000}
  
  validates :user_ip, :presence => true
  
  
end
