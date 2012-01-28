# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "dc_user/version"

Gem::Specification.new do |s|
  s.platform                =   Gem::Platform::RUBY
  s.version                 =   DcUser.version
  s.authors                 =   ["orangenwerk", "2strange", "marcosebald"]
  s.email                   =   "web@orangenwerk.com"
  s.homepage                =   "http://orangenwerk.com"
  s.description             =   "DressCode-CMS .. by orangenwerk .. may be released in 2012"
  
  s.files                   =   Dir['app/**/*', 'config/**/*', 'db/**/*', 'features/**/*', 'lib/**/*', 'spec/**/*']
  s.require_path            =   'lib'
  s.requirements            <<  'none'
  
  
  s.name                    =   'dc_user'
  s.rubyforge_project       =   'dc_user'
  s.summary                 =   'DressCode - User & Login-Functionality'
  
  
  # => s.add_dependency('devise', '= 1.4.2')
  # => s.add_dependency('devise_invitable', '= 0.5.4')
  
  s.add_dependency('devise', '= 1.5.3')
  s.add_dependency('devise_invitable', '= 0.6.1')
  
  
end
