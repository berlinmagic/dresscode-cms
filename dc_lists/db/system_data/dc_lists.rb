   


werteliste_2 = ValueList.create! :name => 'Anrede', :description => 'Herr / Frau - Auswahl.', :system_stuff => true

wert_21 = Value.create! :content => 'Herr', :position => 1, :value_list_id => werteliste_2.id

wert_22 = Value.create! :content => 'Frau', :position => 2, :value_list_id => werteliste_2.id




   