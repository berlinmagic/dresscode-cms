
 

# encoding: utf-8

puts 'CMS_User:: ERSTELLE Gruppen und Rechte:'

owner_rechte = Right.create!(     :show => true,        :new => true,             :modify => true,      :is_master => true,
                                  :edit_own => true,    :edit_group => true,      :edit_all => true,
                                  :del_own => true,     :del_group => true,       :del_all => true
                                  )

owner_gruppe = Group.create!(     :name => 'Seiten-Inhaber',    :system_stuff => true,      :system_name => 'owner',
                                  :backend => true,             :content_admin => true,     :design_admin => true,    
                                  :system_admin => true,        :position => 1,             :rank => 0,
                                  :right_id => owner_rechte.id
                                  )


admin_rechte = Right.create!(     :show => true,        :new => true,             :modify => true,      :is_master => true,
                                  :edit_own => true,    :edit_group => true,      :edit_all => true,
                                  :del_own => true,     :del_group => true,       :del_all => true
                                  )

admin_gruppe = Group.create!(     :name => 'Administrator',    :system_stuff => true,      :system_name => 'admin',
                                  :backend => true,             :content_admin => true,     :design_admin => true,    
                                  :system_admin => true,        :position => 2,             :rank => 1,
                                  :right_id => admin_rechte.id
                                  )


autor_rechte = Right.create!(     :show => true,        :new => true,             :modify => true,      :is_master => true,
                                  :edit_own => true,    :edit_group => true,      :edit_all => false,
                                  :del_own => true,     :del_group => true,       :del_all => false
                                  )

autor_gruppe = Group.create!(     :name => 'Autor',    :system_stuff => true,      :system_name => 'autor',
                                  :backend => true,             :content_admin => true,     :design_admin => true,    
                                  :system_admin => true,        :position => 3,             :rank => 2,
                                  :right_id => autor_rechte.id
                                  )


user_rechte = Right.create!(      :show => true,        :new => true,              :modify => false,      :is_master => true,
                                  :edit_own => true,    :edit_group => false,      :edit_all => false,
                                  :del_own => true,     :del_group => false,       :del_all => false
                                  )

user_gruppe = Group.create!(      :name => 'Benutzer',          :system_stuff => true,      :system_name => 'user',
                                  :backend => true,             :content_admin => true,     :design_admin => true,    
                                  :system_admin => true,        :position => 4,             :rank => 3,
                                  :right_id => user_rechte.id
                                  )


guest_rechte = Right.create!(     :show => true,        :new => false,             :modify => false,      :is_master => true,
                                  :edit_own => true,    :edit_group => false,      :edit_all => false,
                                  :del_own => true,     :del_group => false,       :del_all => false
                                  )

guest_gruppe = Group.create!(     :name => 'Gast',          :system_stuff => true,      :system_name => 'gast',
                                  :backend => true,             :content_admin => true,     :design_admin => true,    
                                  :system_admin => true,        :position => 5,             :rank => 5,
                                  :right_id => guest_rechte.id
                                  )



puts 'INFO: ERSTELLE  USER :1'

master = User.create!(
                              :salutation => 'mr', :first_name =>  'Torsten', :last_name => 'Wetzel',
                              :nick_name => 'dc_austin',  :dc_id => 'owerk_austin',
                              :email => 'admin@orangenwerk.com', 
                              :password => 'dau@mac?!', :password_confirmation => 'dau@mac?!',
                              :evil_master => true, :site_admin => true, :confirmed_at => Time.now,
                              :group_id => admin_gruppe.id
)


puts 'INFO: ERSTELLE  USER :2'

admin = User.create!(
                              :salutation => 'mr', :first_name =>  'Marco', :last_name => 'Sebald',
                              :nick_name => 'dc_marco',  :dc_id => 'owerk_marco',
                              :email => 'm.sebald@orangenwerk.com', 
                              :password => 'blackfish1980', :password_confirmation => 'blackfish1980',
                              :evil_master => false, :site_admin => true, :confirmed_at => Time.now,
                              :group_id => admin_gruppe.id
)



   
