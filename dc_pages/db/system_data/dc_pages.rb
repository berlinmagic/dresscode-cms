# encoding: utf-8
# ich hätt´s gern in utf, dankeschön. ähh .. müßte klappen # => litle joke, to force utf-8 encoding


puts 'INFO: ERSTELLE SEITEN:'
start_site = Page.create!     :name => 'Start',
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
                              :tlayout_id => 1
                              # => :text_content => '' # => depreacated !

puts 'INFO: ERSTELLE SEITEN-Layout'

home_row_one = PageRow.create!     :page_id => start_site.id, :position => 1
home_cell_one = PageCell.create!    :page_row_id => home_row_one.id, :cell_type => '1x1', :position => 1
PageContent.create! :page_cell_id => home_cell_one.id, :text_content => '<h1>Beispiel Start-Seite</h1><br/><p>Laden Sie den editor um diese zu bearbeiten.</p><br/>'


home_row_two = PageRow.create!     :page_id => start_site.id, :position => 2
home_cell_t_one = PageCell.create! :page_row_id => home_row_two.id, :cell_type => '1x2', :position => 1
home_cell_t_two = PageCell.create! :page_row_id => home_row_two.id, :cell_type => '1x2', :position => 2

PageContent.create! :page_cell_id => home_cell_t_one.id, :text_content => '<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum.</p><br/>'
PageContent.create! :page_cell_id => home_cell_t_two.id, :text_content => '<h3>Seite bearbeiten:</h3><a href="/dc/login">Zum Editiermodus wechseln</a><br/><br/><p>Viel Spass ..</p>'




imprint_site = Page.create!   :name => 'Impressum',
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
                              :tlayout_id => 1
                              # => :text_content => '' # => depreacated !

impressum_row_one = PageRow.create!     :page_id => imprint_site.id, :position => 1
impressum_cell_o_one = PageCell.create!    :page_row_id => impressum_row_one.id, :cell_type => '1x2', :position => 1
impressum_cell_o_two = PageCell.create!    :page_row_id => impressum_row_one.id, :cell_type => '1x2', :position => 2
PageContent.create! :page_cell_id => impressum_cell_o_one.id, :text_content => '<p><strong>Vertretungsberechtigte Gesellschafter</strong><br />Manfred Mustermann</p><br/><p><strong>Inhaltlich Verantwortlicher gem&auml;&szlig; &sect; 10 Absatz 3 MDStV</strong><br />Manfred Mustermann</p><br/><p><strong>Achtung, dies ist nur eine Testseite!</strong><br/>Alle Inhalte dienen ausschliesslich als Platzhalter, mögliche Urheberrechtsverletzungen sind unbeabsichtigt und werden im Zuge der Fertigstellung entfernt.</p>'
PageContent.create! :page_cell_id => impressum_cell_o_two.id, :text_content => '<h2>Umgesetzt mit <em>dresscodeCMS</em> von:</h2><p><strong>orangenwerk.</strong><br />Agentur f&uuml;r visuelle Kommunikation</p><p>Stralsunder Stra&szlig;e 20<br />16515 Oranienburg</p><p>Telefon: +49 (0) 3301 - 57 69 00<br />Telefax: +49 (0) 3301 - 57 69 01</p><p><a href="mailto:web@orangenwerk.com?subject=dresscodeCMS">web@orangenwerk.com</a><br /><a href="http://orangenwerk.com"><strong>www.orangenwerk.com</strong></a></p><br/>'


impressum_row_two = PageRow.create!     :page_id => imprint_site.id, :position => 2
impressum_cell_two = PageCell.create!    :page_row_id => impressum_row_two.id, :cell_type => '1x1', :position => 1
PageContent.create! :page_cell_id => impressum_cell_two.id, :text_content => '<p><strong>Copyright</strong><br />Alle Rechte vorbehalten. Texte, Bilder und Grafiken sowie das Layout dieser Seiten genie&szlig;en Urheberschutz.</p><br/>'


impressum_row_three = PageRow.create!     :page_id => imprint_site.id, :position => 3
impressum_cell_three = PageCell.create!    :page_row_id => impressum_row_three.id, :cell_type => '1x1', :position => 1
PageContent.create! :page_cell_id => impressum_cell_three.id, :text_content => '<p><strong>Google Analytics</strong></p>
<p>&bdquo;Diese Website benutzt Google Analytics, einen Webanalysedienst der Google Inc. (&bdquo;Google&ldquo;). Google Analytics verwendet sog. &bdquo;Cookies&ldquo;, Textdateien, die auf Ihrem Computer gespeichert werden und die eine Analyse der Benutzung der Website durch Sie erm&ouml;glichen. Die durch den Cookie erzeugten Informationen &uuml;ber Ihre Benutzung dieser Website (einschlie&szlig;lich Ihrer IP-Adresse) wird an einen Server von Google in den USA &uuml;bertragen und dort gespeichert. Google wird diese Informationen benutzen, um Ihre Nutzung der Website auszuwerten, um Reports &uuml;ber die Websiteaktivit&auml;ten f&uuml;r die Websitebetreiber zusammenzustellen und um weitere mit der Websitenutzung und der Internetnutzung verbundene Dienstleistungen zu erbringen. Auch wird Google diese Informationen gegebenenfalls an Dritte &uuml;bertragen, sofern dies gesetzlich vorgeschrieben oder soweit Dritte diese Daten im Auftrag von Google verarbeiten. Google wird in keinem Fall Ihre IP-Adresse mit anderen Daten von Google in Verbindung bringen. Sie k&ouml;nnen die Installation der Cookies durch eine entsprechende Einstellung Ihrer Browser Software verhindern; wir weisen Sie jedoch darauf hin, dass Sie in diesem Fall gegebenenfalls nicht s&auml;mtliche Funktionen dieser Website vollumf&auml;nglich nutzen k&ouml;nnen. Durch die Nutzung dieser Website erkl&auml;ren Sie sich mit der Bearbeitung der &uuml;ber Sie erhobenen Daten durch Google in der zuvor beschriebenen Art und Weise und zu dem zuvor benannten Zweck einverstanden.&ldquo;</p>'


puts 'INFO: Seiten = Fertig!'


                     