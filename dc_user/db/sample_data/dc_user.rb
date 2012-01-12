the_group = Group.where('system_name == ? ', 'owner').first
owner = User.create!(
                              :salutation => 'mr', :first_name =>  'Manfred', :last_name => 'Musterman',
                              :nick_name => 'Seiten_Inhaber',
                              :email => 'test_owner@2strange.net', 
                              :password => 'fineline_owner', :password_confirmation => 'fineline_owner',
                              :evil_master => false, :site_admin => true, :confirmed_at => Time.now,
                              :group_id => the_group.id
)
