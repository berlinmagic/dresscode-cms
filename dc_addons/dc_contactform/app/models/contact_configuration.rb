# encoding: utf-8
class ContactConfiguration < Configuration
  
  preference    :salutation,          :boolean,     :default => true
  preference    :salutation_needed,   :boolean,     :default => true
  
  preference    :first_name,          :boolean,     :default => false
  preference    :first_name_needed,   :boolean,     :default => false
  
  preference    :last_name,           :boolean,     :default => true
  preference    :last_name_needed,    :boolean,     :default => true
  
  
  preference    :phone_number,        :boolean,     :default => false
  preference    :phone_number_needed, :boolean,     :default => false
  
  preference    :fax_number,          :boolean,     :default => false
  preference    :fax_number_needed,   :boolean,     :default => false
  
  preference    :mobil_number,        :boolean,     :default => false
  preference    :mobil_number_needed, :boolean,     :default => false
  
  
  preference    :company,             :boolean,     :default => false
  preference    :company_needed,      :boolean,     :default => false
  
  preference    :website,             :boolean,     :default => false
  preference    :website_needed,      :boolean,     :default => false
  
  preference    :street,              :boolean,     :default => false
  preference    :street_needed,       :boolean,     :default => false
  
  preference    :zip,                 :boolean,     :default => false
  preference    :zip_needed,          :boolean,     :default => false
  
  preference    :city,                :boolean,     :default => false
  preference    :city_needed,         :boolean,     :default => false
  
  
  preference    :mail_subject,        :boolean,     :default => false
  preference    :mail_subject_needed, :boolean,     :default => false
  preference    :default_subject,     :string,      :default => "Kontakt-Anfrage"
  
  
  FIELD_TYPES = %w[text_field text_area date datetime time]
  
  preference    :field_1,             :boolean,     :default => true
  preference    :field_1_needed,      :boolean,     :default => false
  preference    :field_1_name,        :string,      :default => 'Ihre Stimmnung?'
  preference    :field_1_type,        :string,      :default => 'text_field'
  
  preference    :field_2,             :boolean,     :default => false
  preference    :field_2_needed,      :boolean,     :default => false
  preference    :field_2_name,        :string,      :default => 'FreeField 2'
  preference    :field_2_type,        :string,      :default => 'text_field'
  
  preference    :field_3,             :boolean,     :default => false
  preference    :field_3_needed,      :boolean,     :default => false
  preference    :field_3_name,        :string,      :default => 'FreeField 3'
  preference    :field_3_type,        :string,      :default => 'text_field'
  

end
