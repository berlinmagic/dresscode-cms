# encoding: utf-8
class CreateContactForms < ActiveRecord::Migration
  
  def up
    
    create_table(:contact_forms) do |t|
      
      t.string      :salutation
      t.string      :first_name
      t.string      :last_name
      
      t.string      :email,                             :default => "",       :null => false
      
      t.string      :phone_number
      t.string      :fax_number
      t.string      :mobil_number
      
      t.string      :company
      t.string      :website
      
      t.string      :street
      t.string      :zip
      t.string      :city
      
      t.text        :mail_subject
      t.text        :mail_content
      
      t.string      :field_1_name
      t.text        :field_1_value
      t.string      :field_1_type
      
      t.string      :field_2_name
      t.text        :field_2_value
      t.string      :field_2_type
      
      t.string      :field_3_name
      t.text        :field_3_value
      t.string      :field_3_type
      
      
      t.string      :user_ip,                           :default => "",       :null => false
      t.boolean     :unread,                            :default => true
      t.boolean     :answered,                          :default => false
      t.integer     :answer_for
      
      t.timestamps
    end
    
  end
  
  def down
    drop_table :contact_forms
  end
  
end