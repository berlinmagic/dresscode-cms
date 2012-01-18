# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "dc_themes_dynamic/version"

Gem::Specification.new do |s|
  s.platform                =   Gem::Platform::RUBY
  s.required_ruby_version   =   '>= 1.8.7'
  s.version                 =   DcThemesDynamic.version
  s.authors                 =   ["orangenwerk", "2strange", "marcosebald"]
  s.email                   =   "web@orangenwerk.com"
  s.homepage                =   "http://orangenwerk.com"
  s.description             =   "DressCode-CMS .. by orangenwerk .. may be released in 2012"
  
  s.files                   =   Dir['app/**/*', 'config/**/*', 'db/**/*', 'features/**/*', 'lib/**/*', 'spec/**/*']
  s.require_path            =   'lib'
  s.requirements            <<  'none'
  
  
  s.name                    =   'dc_themes_dynamic'
  s.rubyforge_project       =   'dc_themes_dynamic'
  s.summary                 =   'DressCode - Dynamic Theme & Style - Functionality'
  
  
  s.add_dependency('yui-compressor', '>= 0.9.6')
  
end
