# encoding: utf-8
# ich hätt´s gern in utf, dankeschön. ähh .. müßte klappen # => litle joke, to force utf-8 encoding

the_group = Group.where('system_name == ? ', 'owner').first
owner = User.create!(
                              :salutation => 'mr', :first_name =>  'Manfred', :last_name => 'Musterman',
                              :nick_name => 'Seiten_Inhaber',
                              :email => 'test_owner@2strange.net', 
                              :password => 'fineline_owner', :password_confirmation => 'fineline_owner',
                              :confirmed_at => Time.now,
                              :group_id => the_group.id
)


   
   