# encoding: utf-8
# ich hätt´s gern in utf, dankeschön. ähh .. müßte klappen # => litle joke, to force utf-8 encoding


puts 'INFO: ERSTELLE SEITEN:'
home = Page.create!           :name => 'Start',
                              :site_type => 'system', 
                              :system_name => 'start',
                              :use_title => true,
                              :title => 'dresscode Startseite',
                              :headline_type => 'headline',
                              :headline => 'dresscode Standard Startseite',
                              :slug => '/',
                              :in_sec_nav => true, 
                              :in_system_nav => false, 
                              :in_main_nav => true, 
                              :meta_description => 'dresscode CMS - Standard Start-Seite', 
                              :meta_keywords => 'dresscode CMS, orangenwerk',
                              :tlayout_id => 1,
                              :text_content => '<h1>N E U &nbsp;! ! !</h1><p>&nbsp;</p><p>&nbsp;</p><p><strong>Ab jetzt werden &Auml;nderungen an Seiten aufgezeichnet, dass hei&szlig;t man kann jede Vorg&auml;nger-Version wiederherstellen.</strong></p><p>&nbsp;</p><p>&nbsp;</p><p><em>Klingt toll? .. na dann sofort mal Ausprobieren !</em></p><p>&nbsp;</p><ul><li>einfach anmelden unter <a href="/users/sign_in"><u><strong>login</strong></u></a></li><br /><li>Dann im <a href="/admin"><u><strong>Admin-Dashboard</strong></u></a> eine &Auml;nderung ausw&auml;hlen</li><br /><li>oder die betreffende Seite im Admin-Bereich anschauen zB: <a href="/admin/seiten/1"><u><strong>Home</strong></u></a></li><br /></ul><br/><br/><p>Testen Sie unser CMS ... melden Sie sich mit E-Mail:<br/><strong>test_user@2strange.net</strong><br/><br/>und Password:<br/><strong>demotest</strong><br/><br/>beim System an.</p>'




impressum = Page.create!      :name => 'Impressum',
                              :site_type => 'system', 
                              :system_name => 'impressum',
                              :use_title => true,
                              :title => 'dresscode Impressum',
                              :headline_type => 'headline',
                              :headline => 'Impressum',
                              :slug => '/',
                              :in_sec_nav => true, 
                              :in_system_nav => true, 
                              :in_main_nav => false, 
                              :meta_description => 'dresscode CMS - Standard Impressum', 
                              :meta_keywords => 'dresscode CMS, orangenwerk',
                              :tlayout_id => 1,
                              :text_content => '<p><strong>Vertretungsberechtigte Gesellschafter</strong><br />User_Name</p><br/><p><strong>Inhaltlich Verantwortlicher gem&auml;&szlig; &sect; 10 Absatz 3 MDStV</strong><br />User_Name</p><br/><h2>Umgesetzt mit <em>dresscodeCMS</em> von:</h2><p><strong>orangenwerk.</strong><br />Agentur f&uuml;r visuelle Kommunikation</p><p>Stralsunder Stra&szlig;e 20<br />16515 Oranienburg</p><p>Telefon: +49 (0) 3301 - 57 69 00<br />Telefax: +49 (0) 3301 - 57 69 01</p><p><a href="mailto:web@orangenwerk.com?subject=dresscodeCMS">web@orangenwerk.com</a><br /><a href="http://orangenwerk.com"><strong>www.orangenwerk.com</strong></a></p><br/><p><strong>Copyright</strong><br />Alle Rechte vorbehalten. Texte, Bilder und Grafiken sowie das Layout dieser Seiten genie&szlig;en Urheberschutz.</p><br/><p><strong>Google Analytics</strong></p>
<p>&bdquo;Diese Website benutzt Google Analytics, einen Webanalysedienst der Google Inc. (&bdquo;Google&ldquo;). Google Analytics verwendet sog. &bdquo;Cookies&ldquo;, Textdateien, die auf Ihrem Computer gespeichert werden und die eine Analyse der Benutzung der Website durch Sie erm&ouml;glichen. Die durch den Cookie erzeugten Informationen &uuml;ber Ihre Benutzung dieser Website (einschlie&szlig;lich Ihrer IP-Adresse) wird an einen Server von Google in den USA &uuml;bertragen und dort gespeichert. Google wird diese Informationen benutzen, um Ihre Nutzung der Website auszuwerten, um Reports &uuml;ber die Websiteaktivit&auml;ten f&uuml;r die Websitebetreiber zusammenzustellen und um weitere mit der Websitenutzung und der Internetnutzung verbundene Dienstleistungen zu erbringen. Auch wird Google diese Informationen gegebenenfalls an Dritte &uuml;bertragen, sofern dies gesetzlich vorgeschrieben oder soweit Dritte diese Daten im Auftrag von Google verarbeiten. Google wird in keinem Fall Ihre IP-Adresse mit anderen Daten von Google in Verbindung bringen. Sie k&ouml;nnen die Installation der Cookies durch eine entsprechende Einstellung Ihrer Browser Software verhindern; wir weisen Sie jedoch darauf hin, dass Sie in diesem Fall gegebenenfalls nicht s&auml;mtliche Funktionen dieser Website vollumf&auml;nglich nutzen k&ouml;nnen. Durch die Nutzung dieser Website erkl&auml;ren Sie sich mit der Bearbeitung der &uuml;ber Sie erhobenen Daten durch Google in der zuvor beschriebenen Art und Weise und zu dem zuvor benannten Zweck einverstanden.&ldquo;</p>'         


puts 'INFO: Seiten = Fertig!'


                     