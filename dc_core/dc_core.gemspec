# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "dc_core/version"

Gem::Specification.new do |s|
  s.platform                =   Gem::Platform::RUBY
  s.version                 =   DcCore.version
  
  s.authors                 =   ["orangenwerk", "2strange", "marcosebald"]
  s.email                   =   "web@orangenwerk.com"
  s.homepage                =   "http://orangenwerk.com"
  
  s.summary                 =   'DressCode - Core-Functionality'
  s.description             =   "DressCode-CMS .. by orangenwerk .. may be released in 2012"
  
  s.name                    =   'dc_core'
  s.rubyforge_project       =   'dc_core'
  
  
  s.files                   =   Dir['app/**/*', 'config/**/*', 'db/**/*', 'lib/**/*', 'public/**/*']
  s.require_path            =   'lib'
  s.requirements            <<  'none'
  
  
  # Dragonfly to handle Images & Uploads generelly
  s.add_dependency( 'rack-cache',         '~> 1.1' )
  s.add_dependency( 'dragonfly',          '~> 0.9.10' )
  
  # old rMagick image_processors should be translated to ImageMagick !!!
  # => s.add_dependency( 'dragonfly',          '0.9.5' )
  # => s.add_dependency( 'rmagick',            '2.13.1' )
  # => s.add_dependency( 'dragonfly-rmagick',  '0.0.33' )
  
  s.add_dependency( 'cells',              '~> 3.8.0' ) ## also required in themes_static !
  # s.add_dependency( 'apotomo', '~> 1.2.2' ) # =>  maybe better than cells ???
  
end
