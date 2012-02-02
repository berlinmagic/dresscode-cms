# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dc_carte/version"

Gem::Specification.new do |s|
  s.platform                =   Gem::Platform::RUBY
  s.version                 =   DcCarte::VERSION

  s.authors                 =   ["orangenwerk", "2strange", "marcosebald"]
  s.email                   =   "web@orangenwerk.com"
  s.homepage                =   "http://orangenwerk.com"

  s.summary                 =   %q{dresscode-extension: carte }
  s.description             =   "dc_carte is an extension for dresscode-CMS .. by orangenwerk .. may be released in 2012"
  
  s.name                    =   "dc_carte"
  s.rubyforge_project       =   "dc_carte"

  s.files                   =   Dir['app/**/*', 'config/**/*', 'db/**/*', 'lib/**/*']
  s.require_path            =   'lib'
  s.requirements            <<  'none'

  # dependencies here:

  s.add_dependency('dresscode',  ">= 0.0.1")

end
