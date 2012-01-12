# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "dc_editor/version"

Gem::Specification.new do |s|
  s.platform                =   Gem::Platform::RUBY
  s.required_ruby_version   =   '>= 1.8.7'
  s.version                 =   DcEditor.version
  s.authors                 =   ["orangenwerk", "2strange", "marcosebald"]
  s.email                   =   "web@orangenwerk.com"
  s.homepage                =   "http://orangenwerk.com"
  s.description             =   "DressCode-CMS .. by orangenwerk .. may be released in 2012"
  
  s.files                   =   Dir['annotated_source/**/*', 'app/**/*', 'config/**/*', 'db/**/*', 'features/**/*', 'lib/**/*', 'spec/**/*', 'vendor/**/*']
  s.require_path            =   'lib'
  s.requirements            <<  'none'
  
  
  s.name                    =   'dc_editor'
  s.rubyforge_project       =   'dc_editor'
  s.summary                 =   'DressCode - WYSIWYG-Functionality build of DcEditor-Editor'
  

  
  # Runtime Dependencies
  s.add_runtime_dependency('paperclip')
  s.add_runtime_dependency('coffee-script')


  # Development Dependencies
  s.add_development_dependency('rocco')
  s.add_development_dependency('uglifier')
  s.add_development_dependency('jquery-rails')
  s.add_development_dependency('sqlite3')
  s.add_development_dependency('thin')
  s.add_development_dependency('ruby-debug19')
  s.add_development_dependency('evergreen')
  s.add_development_dependency('selenium-webdriver')
  s.add_development_dependency('cucumber-rails')
  s.add_development_dependency('fuubar-cucumber')
  s.add_development_dependency('capybara')
  s.add_development_dependency('capybara-firebug')
  s.add_development_dependency('database_cleaner')
  
  
end
