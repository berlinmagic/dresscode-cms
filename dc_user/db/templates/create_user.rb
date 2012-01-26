class CreateUser < ActiveRecord::Migration
  
  def up
    
    
    create_table(:users) do |t|
      t.string      :email,                               :default => "", :null => false
      # DressCode
      t.string      :salutation                          # => Anrede
      t.string      :first_name
      t.string      :last_name
      t.string      :dc_id
      t.string      :nick_name
      t.string      :image_uid
      t.string      :image_cropping
      t.boolean     :evil_master,                         :default => false
      t.boolean     :site_admin,                          :default => false
      t.integer     :group_id
      # Devise
      t.string      :encrypted_password,     :limit => 128, :default => ""
      t.string      :reset_password_token
      t.datetime    :reset_password_sent_at
      t.datetime    :remember_created_at
      t.integer     :sign_in_count,                         :default => 0
      t.datetime    :current_sign_in_at
      t.datetime    :last_sign_in_at
      t.string      :current_sign_in_ip
      t.string      :last_sign_in_ip
      t.string      :password_salt
      t.string      :confirmation_token
      t.datetime    :confirmed_at
      t.datetime    :confirmation_sent_at
      t.integer     :failed_attempts,                       :default => 0
      t.string      :unlock_token
      t.datetime    :locked_at
      t.string      :authentication_token
      # Rails
      t.string      :invitation_token,       :limit => 60
      t.datetime    :invitation_sent_at
      t.datetime    :invitation_accepted_at
      t.integer     :invitation_limit
      t.integer     :invited_by_id
      t.string      :invited_by_type
      # Rails
      t.datetime    :created_at
      t.datetime    :updated_at
    end
    add_index :users, :authentication_token, :unique => true
    add_index :users, :confirmation_token, :unique => true
    add_index :users, :email, :unique => true
    add_index :users, :group_id
    add_index :users, :invitation_token
    add_index :users, :invited_by_id
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :unlock_token, :unique => true
    
    # => create_table "users", :force => true do |t|
    # =>   t.string   :email,                               :default => "",    :null => false
    # =>   # => Devise <= #
    # =>   t.string   :encrypted_password,   :limit => 128, :default => ""
    # =>   t.string   :password_salt,                       :default => ""
    # =>   t.string   :reset_password_token
    # =>   t.string   :remember_token
    # =>   t.datetime :remember_created_at
    # =>   t.integer  :sign_in_count,                       :default => 0
    # =>   t.datetime :current_sign_in_at
    # =>   t.datetime :last_sign_in_at
    # =>   t.string   :current_sign_in_ip
    # =>   t.string   :last_sign_in_ip
    # =>   t.string   :confirmation_token
    # =>   t.datetime :confirmed_at
    # =>   t.datetime :confirmation_sent_at
    # =>   t.integer  :failed_attempts,                     :default => 0
    # =>   t.string   :unlock_token
    # =>   t.datetime :locked_at
    # =>   t.string   :authentication_token
    # =>   # => Devise invitation <= #
    # =>   t.string   :invitation_token,     :limit => 20
    # =>   t.datetime :invitation_sent_at
    # =>   # DC
    # =>   t.string   :salutation                          # => Anrede
    # =>   t.string   :first_name,                         :default => ""
    # =>   t.string   :last_name,                          :default => ""
    # =>   t.string   :dc_id,                              :default => ""
    # =>   t.string   :nick_name,                          :default => ""
    # =>   t.string   :image_uid
    # =>   t.string   :image_cropping
    # =>   t.boolean  :evil_master,                         :default => false
    # =>   t.boolean  :site_admin,                          :default => false
    # =>   t.references  :group
    # =>   t.timestamps
    # => end
    # => add_index :users, :confirmation_token,        :unique => true
    # => add_index :users, :email,                     :unique => true
    # => add_index :users, :invitation_token
    # => add_index :users, :dc_id,                     :unique => true
    # => add_index :users, :nick_name,                 :unique => true
    # => add_index :users, :reset_password_token,      :unique => true
    # => add_index :users, :unlock_token,              :unique => true
    
    create_table(:groups) do |t|
      t.string      :name,          :null => false
      t.boolean     :system_stuff,  :default => false
      t.string      :system_name
      t.boolean     :content_admin, :default => false
      t.boolean     :design_admin,  :default => false
      t.boolean     :system_admin,  :default => false
      t.boolean     :backend,       :default => false
      
      t.integer     :position
      t.integer     :rank,          :default => 3
      
      t.references  :right
      
      t.timestamps
    end
    add_index :groups, :right_id
    
    create_table(:rights) do |t|
      t.boolean     :show,           :default => true
      t.boolean     :new,            :default => false
      t.boolean     :edit_own,       :default => false
      t.boolean     :edit_group,      :default => false
      t.boolean     :edit_all,       :default => false
      t.boolean     :del_own,        :default => false
      t.boolean     :del_group,       :default => false
      t.boolean     :del_all,        :default => false
      t.boolean     :modify,         :default => false
      
      t.boolean     :is_master,         :default => false
      
      t.references  :group
      t.references  :right_module
      t.references  :user
      t.timestamps
    end
    add_index :rights, :group_id
    add_index :rights, :right_module_id
    add_index :rights, :user_id
    
    
    create_table(:right_modules) do |t|
      t.string      :name
      t.string      :front_url
      t.string      :admin_url
      t.string      :prefs_url
      
      t.timestamps
    end
    
      
  end

  def down
    drop_table :users
    drop_table :groups
    drop_table :rights
    drop_table :right_modules
  end
  
  
end