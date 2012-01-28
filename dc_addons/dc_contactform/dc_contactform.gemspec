# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dc_contactform/version"

Gem::Specification.new do |s|
  s.platform                =   Gem::Platform::RUBY
  s.required_ruby_version   =   '>= 1.8.7'
  s.version                 =   DcContactform::VERSION
  s.authors                 =   ["orangenwerk", "2strange", "marcosebald"]
  s.email                   =   "web@orangenwerk.com"
  s.homepage                =   "http://orangenwerk.com"
  s.description             =   "DressCode-CMS .. by orangenwerk .. may be released in 2012"
  
  s.name                    =   "dc_contactform"
  s.rubyforge_project       =   "dc_contactform"
  s.summary                 =   %q{DressCode-CMS contact-forms}

  

  s.files                   =   Dir['app/**/*', 'config/**/*', 'db/**/*', 'features/**/*', 'lib/**/*', 'spec/**/*']
  s.require_path            =   'lib'
  s.requirements            <<  'none'

  # dependencies here
  
  
end
