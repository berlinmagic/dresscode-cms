# encoding: binary
ActiveRecord::Base.class_eval do
  
  include MailReg
  
  def self.validate_email_field(attr_name, value, options={})
    # .. add docu !
    unless value =~ EmailAddress
      self.errors[attribute] << (options[:message] || I18n.t('activerecord.errors.messages.email_error_message')) 
    end
  end
  
end