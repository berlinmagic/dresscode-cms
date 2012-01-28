# dresscode-cms

# Usage

## Gemfile
	
	source 'http://rubygems.org'
	
	gem 'rails', '3.1.3'
	
	gem 'sqlite3'
	
	gem 'json'
	
	gem 'coffee-rails', '~> 3.1.1'
	
	gem 'jquery-rails'
	
	gem 'dresscode', :path => '../dresscode_31'
	
	gem 'dc_contactform', :path => '../dresscode_31/dc_addons/dc_contactform'
	

## Install dresscode
	
	rails g dresscode:install
	



# ToDo's:

## Pages
	index
	row / cell => sorting
	row / cell / content => edit / delete
## Users
	index
	show
	invite / new
	more_actions => password_reset / sign_up / etc.
## Settings
	index => readable/usable for important settings
	show => readable/usable for all settings
	edit => readable/usable for all settings
## System
	icon_helper
	Config[:styles] ?
## DataFiles
	index
	show
	new
	actions => delete / new_attachment / crop if pic