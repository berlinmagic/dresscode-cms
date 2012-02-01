# encoding: utf-8
class ContactForm < ActiveRecord::Base
  
  MAIL_TYPES = ['mail_in', 'mail_out', 'mail_unread', 'mail_readed']
  
  SALUTATIONS = ['mr', 'ms']
  
  attr_accessor       :this_site
  
  scope :mail_in, where( :answer_for => nil )
  scope :mail_out, where( :answer_for != nil )
  scope :mail_unread, where( :unread => true )
  scope :mail_readed, where( :unread => false )
  
  #   default_scope :order => "created_at DESC"
  
  # Optional Validations
  validates :salutation, :presence => true    if DC::Contact::Config[:salutation] && DC::Contact::Config[:salutation_needed]
  validates :first_name, :presence => true    if DC::Contact::Config[:first_name] && DC::Contact::Config[:first_name_needed]
  validates :last_name, :presence => true     if DC::Contact::Config[:last_name] && DC::Contact::Config[:last_name_needed]
  validates :phone_number, :presence => true  if DC::Contact::Config[:phone_number] && DC::Contact::Config[:phone_number_needed]
  validates :fax_number, :presence => true    if DC::Contact::Config[:fax_number] && DC::Contact::Config[:fax_number_needed]
  validates :mobil_number, :presence => true  if DC::Contact::Config[:mobil_number] && DC::Contact::Config[:mobil_number_needed]
  validates :company, :presence => true       if DC::Contact::Config[:company] && DC::Contact::Config[:company_needed]
  validates :website, :presence => true       if DC::Contact::Config[:website] && DC::Contact::Config[:website_needed]
  validates :street, :presence => true        if DC::Contact::Config[:street] && DC::Contact::Config[:street_needed]
  validates :zip, :presence => true           if DC::Contact::Config[:zip] && DC::Contact::Config[:zip_needed]
  validates :city, :presence => true          if DC::Contact::Config[:city] && DC::Contact::Config[:city_needed]
  validates :mail_subject, :presence => true  if DC::Contact::Config[:mail_subject] && DC::Contact::Config[:mail_subject_needed]
  validates :field_1, :presence => true       if DC::Contact::Config[:field_1] && DC::Contact::Config[:field_1_needed]
  validates :field_2, :presence => true       if DC::Contact::Config[:field_2] && DC::Contact::Config[:field_2_needed]
  validates :field_3, :presence => true       if DC::Contact::Config[:field_3] && DC::Contact::Config[:field_3_needed]
  
  
  # Standard Validations
  validates :email, :presence => true, :email => true
  validates :mail_content,  :presence => true, :length => {:minimum => 3, :maximum => 5000}
  validates :user_ip, :presence => true
  
  
end
