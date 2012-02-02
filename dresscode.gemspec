# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "dc/version"

Gem::Specification.new do |s|
  s.platform                =   Gem::Platform::RUBY
  s.required_ruby_version   =   '>= 1.9.2'
  s.version                 =   DC.version
  s.authors                 =   ["orangenwerk", "2strange", "marcosebald"]
  s.email                   =   "web@orangenwerk.com"
  s.homepage                =   "http://orangenwerk.com"
  s.description             =   "DressCode-CMS .. by orangenwerk .. may be released in 2012"
  
  s.files                   =   Dir['lib/**/*']
  s.require_path            =   'lib'
  s.requirements            <<  'none'
  
  
  s.name                    =   'dresscode'
  s.rubyforge_project       =   'dresscode'
  s.summary                 =   'DressCode - MainSystem'
  
  
  # => Rails-Version chould be the latest !
  s.add_dependency( 'rails',                '>= 3.1.3' )
  
  # => Load the DressCode-Gems
  s.add_dependency( 'dc_core',              '>= 0.0.1' )
  
  s.add_dependency( 'dc_mercury',           '>= 0.0.1' )
  
  s.add_dependency( 'dc_pages',             '>= 0.0.1' )
  
  s.add_dependency( 'dc_themes_static',     '>= 0.0.1' )
  s.add_dependency( 'dc_themes_dynamic',    '>= 0.0.1' )
  
  s.add_dependency( 'dc_user',              '>= 0.0.1' )
  
  
end