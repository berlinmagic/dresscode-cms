# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "dc_core/version"

Gem::Specification.new do |s|
  s.platform                =   Gem::Platform::RUBY
  s.version                 =   DcCore.version
  s.authors                 =   ["orangenwerk", "2strange", "marcosebald"]
  s.email                   =   "web@orangenwerk.com"
  s.homepage                =   "http://orangenwerk.com"
  s.description             =   "DressCode-CMS .. by orangenwerk .. may be released in 2012"
  
  s.files                   =   Dir['app/**/*', 'config/**/*', 'db/**/*', 'lib/**/*', 'public/**/*']
  s.require_path            =   'lib'
  s.requirements            <<  'none'
  
  
  s.name                    =   'dc_core'
  s.rubyforge_project       =   'dc_core'
  s.summary                 =   'DressCode - Core-Functionality'
  
  
  # => Dragonfly to handle Images & Uploads generelly
  s.add_dependency( 'rack-cache',         '~> 1.1' )
  s.add_dependency( 'dragonfly',          '~> 0.9.10' )
  
  # => rMagick could be striped out if image_processors get translated to ImageMagick
  # => s.add_dependency( 'dragonfly',          '0.9.5' )
  # => s.add_dependency( 'rmagick',            '~> 2.13.1' )
  # => s.add_dependency( 'dragonfly-rmagick',  '~> 0.0.33' )
  
  # => Cells may be replaced by apotomo / boxes
  s.add_dependency( 'cells',              '~> 3.8.0' ) ## maybe moved to pages ?
  # => s.add_dependency( 'apotomo',              '~> 1.2.2' ) # maybe testet
  
  
  # => s.add_dependency( 'dc_hook_support',            '~> 0.0.1' ) .. included in core again !
  
end
