# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dc_tags/version"

Gem::Specification.new do |s|
  s.platform                =   Gem::Platform::RUBY
  s.version                 =   DcTags::VERSION

  s.authors                 =   ["orangenwerk", "2strange", "marcosebald"]
  s.email                   =   "web@orangenwerk.com"
  s.homepage                =   "http://orangenwerk.com"

  s.summary                 =   %q{dresscode-extension: tags }
  s.description             =   "dc_tags is an extension for dresscode-CMS .. by orangenwerk .. may be released in 2012"
  
  s.name                    =   "dc_tags"
  s.rubyforge_project       =   "dc_tags"

  s.files                   =   Dir['app/**/*', 'config/**/*', 'db/**/*', 'lib/**/*']
  s.require_path            =   'lib'
  s.requirements            <<  'none'

  # dependencies here:

  s.add_dependency('dresscode',  ">= 0.0.1")

end
