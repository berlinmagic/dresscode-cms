# encoding: utf-8
# ich hätt´s gern in utf, dankeschön. ähh .. müßte klappen # => litle joke, to force utf-8 encoding

site_owner = User.new(    :salutation => 'mr',
                          :first_name =>  'Manfred',
                          :last_name => 'Musterman',
                          :nick_name => 'Seiten_Inhaber',
                          :email => 'test_owner@2strange.net',
                          :password => 'dresscode',
                          :password_confirmation => 'dresscode',
                          :confirmed_at => Time.now,
                          :group_id => 1                      )

# => site_owner.confirm! 
site_owner.skip_confirmation!
site_owner.save
   