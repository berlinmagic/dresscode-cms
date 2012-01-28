# encoding: utf-8
# 
# 
puts 'INFO: create example Contact-Form 1'
ContactForm.create!(
        :salutation   => "herr",
        :first_name   => "Austin",
        :last_name    => "Strange",
        
        :email        => "admin@orangenwerk.com",
        
        :company      => "orangenwerk",
        :website      => "http://orangenwerk.com",
        
        :phone_number => "03301 / 57 69 00",
        :fax_number   => "03301 / 57 69 01",
        
        :street       => "Stralsunder Str. 60",
        :zip          => "16515",
        :city         => "Oranienburg",
        
        :mail_subject => "dresscodeCMS geht online",
        :mail_content => "Wir freuen uns Ihnen mitteilen zu können, dass unser eigens für Sie entwickelstes CMS online ist.\n\n\nProbieren Sie es aus!",
        
        :user_ip      => "00.0.0.00",
        
        :created_at   => (Time.now - 14.days)
)

puts 'INFO: create example Contact-Form 2'
ContactForm.create!(
        :salutation   => "herr",
        :first_name   => "Marc",
        :last_name    => "Weber",
        
        :email        => "web@orangenwerk.com",
        
        :company      => "orangenwerk",
        :website      => "http://orangenwerk.com",
        
        :phone_number => "03301 / 57 69 00",
        :fax_number   => "03301 / 57 69 01",
        
        :street       => "Stralsunder Str. 60",
        :zip          => "16515",
        :city         => "Oranienburg",
        
        :mail_subject => "Herrzlich Willkommen!",
        :mail_content => "Wir begrüssen Sie auf Ihrer neuen Seite und wünschen viel spass und erfolg damit.\nSollten Sie fragen oder anregungen zu unserem CMS haben, kontaktieren Sie uns.\n\norangenwerk\nStralsunder Str. 20\n16515 Oranienburg\n\n03301 / 57 69 00\ninfo@orangenwerk.com",
        
        :user_ip      => "00.0.0.00",
        
        :created_at   => (Time.now - 14.days)
)

puts 'INFO: create example Contact-Form 3'
ContactForm.create!(
        :salutation   => "herr",
        :first_name   => "Austin",
        :last_name    => "Strange",
        
        :email        => "admin@orangenwerk.com",
        
        :company      => "orangenwerk",
        :website      => "http://orangenwerk.com",
        
        :phone_number => "03301 / 57 69 00",
        :fax_number   => "03301 / 57 69 01",
        
        :street       => "Stralsunder Str. 60",
        :zip          => "16515",
        :city         => "Oranienburg",
        
        :mail_subject => "Aller Anfang ist schwer!",
        :mail_content => "Ich begrüsse Sie auf Ihrer neuen Seite und wünschen viel spass und erfolg damit.\n\nHaben Sie bitte keine Berührungsängste, Ihre neue Seite wird Sie nicht beissen und wir haben sie so konzipiert das Sie ohne Vorwarnung nichts unwiederruflich zerstören können.\nEin mächtiges BackUp-System ist in Arbeit, bis dies jedoch fertig ist sollten Sie folgendes beachten:\n - Sie können keine System-Seiten löschen (Kontakt, Impressum, Start, ..), dies ist erforderlich um die Seitenfunktion zu gewährleisten\n - Seiten welche Sie gelöscht haben, landen zunächst im Papierkorb und können Wiederhergestellt werden\n\n - Achtung: Text-Abschnitte sind momentan nicht gesichert, ändern Sie diese sorgfältig! (Sie können im Text-Editor je nach Betriebssystem mit [STRG]+[Z] oder mit [cmd]+[Z] Rückgängig machen.)\n\nAnsonsten haben wir versucht alles selbsterklärend zu gestallten, drum schauen Sie sich erstmal um und lernen Sie Ihre neue Seite kennen.\n\n\nSollten Sie Fehler oder störungen entdecken, wenden Sie sich bitte an mich.\n\n.. Ihr Administrator: Austin Strange [ admin@orangenwerk.com ]",
        
        :user_ip      => "00.0.0.00",
        
        :created_at   => (Time.now - 14.days)
)

puts 'INFO: create example Contact-Form 4'
ContactForm.create!(
        :salutation   => "frau",
        :first_name   => "Sibille",
        :last_name    => "Sorgenfrei",
        
        :email        => "support@orangenwerk.com",
        
        :company      => "orangenwerk",
        :website      => "http://orangenwerk.com",
        
        :phone_number => "03301 / 57 69 00",
        :fax_number   => "03301 / 57 69 01",
        
        :street       => "Stralsunder Str. 60",
        :zip          => "16515",
        :city         => "Oranienburg",
        
        :mail_subject => "Sind Sie zufrieden?",
        :mail_content => "Wir hoffen Sie sind mit Ihrer neuen Seite zufrieden, sollte mal etwas nicht Ihrer Zufriedenheit entsprechen, geben Sie bescheid, wir sehen was sich tun lässt.\n\nIhr support-Team.\nSibille Sorgenfrei\nsupport@orangenwerk.com",
        
        :user_ip      => "00.0.0.00",
        
        :created_at   => (Time.now - 14.days)
)

puts 'INFO: finished example Forms'


