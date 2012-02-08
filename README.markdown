# dresscode-cms

# Usage

## Gemfile
	
	source 'http://rubygems.org'
	
	gem 'rails', 			'~> 3.1.3'
	gem 'coffee-rails', 	'~> 3.1.1'
	gem 'json'
	
	gem 'sqlite3'
	
	gem 'dresscode', 		:path => '../dresscode_31'
	
	gem 'dc_carte', 		:path => '../dresscode_31/dc_addons/dc_carte'
	
	gem 'dc_contactform', 	:path => '../dresscode_31/dc_addons/dc_contactform'
	
	gem 'dc_header', 		:path => '../dresscode_31/dc_addons/dc_header'
	
	gem 'dc_sidebar', 		:path => '../dresscode_31/dc_addons/dc_sidebar'
	
	gem 'dc_tags', 			:path => '../dresscode_31/dc_addons/dc_tags'
	



## Generators:

	rails g dresscode:install
install the CMS and mirror all needed files
	
	
	rails g dresscode:theme name
generates a new theme-gem 'dc_theme_name'
	
	
	rails g dresscode:module name
generates a new extension-gem 'dc_name'
	
	
	rails g dresscode:module_with_config name
generates a new extension-gem 'dc_name' with DC::Name::Conig[:files] - Configuration-Files



# ToDo's:

## Pages
	index
	row / cell => sorting
	row / cell / content => edit / delete
## System
	icon_helper
	Config[:styles] ?!