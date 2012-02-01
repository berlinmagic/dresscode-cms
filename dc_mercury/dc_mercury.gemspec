# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dc_mercury/version"

Gem::Specification.new do |s|
  s.platform                =   Gem::Platform::RUBY
  s.version                 =   DcMercury::VERSION

  s.authors                 =   ['Jeremy Jackson', "2strange"]
  s.email                   =   ['jejacks0n@gmail.com', "web@orangenwerk.com"]
  s.homepage                =   'http://github.com/jejacks0n/mercury'
  s.licenses                =   ['MIT']

  s.summary                 =   %q{dresscode-extension: dc_mercury WYSIWYG editor written in CoffeeScript by Jeremy Jackson}
  s.description             =   "dc_mercury is an extension for dresscode-CMS .. WYSIWYG editor written in CoffeeScript by Jeremy Jackson"
  
  s.name                    =   "dc_mercury"
  s.rubyforge_project       =   "dc_mercury"

  s.extra_rdoc_files        =   ["LICENSE"]
  
  s.files                   =   Dir['app/**/*', 'config/**/*', 'db/**/*', 'lib/**/*', 'public/**/*']
  s.require_path            =   'lib'
  s.requirements            <<  'none'

  # dependencies here:
  s.add_dependency('rails',  ">= 3.1.3")
  s.add_dependency('paperclip')
  s.add_dependency('coffee-script')
  s.add_dependency('dresscode',  ">= 0.0.1")
  

end
