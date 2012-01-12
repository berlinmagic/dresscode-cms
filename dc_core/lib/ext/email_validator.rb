# encoding: binary
class EmailValidator < ActiveModel::EachValidator
  
  include MailReg
  
  def validate_each(record, attribute, value)
    unless value =~ EmailAddress
      record.errors[attribute] << (options[:message] || I18n.t('activerecord.errors.messages.email_error_message')) 
    end
  end
  
end
