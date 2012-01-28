# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "dc_pages/version"

Gem::Specification.new do |s|
  s.platform                =   Gem::Platform::RUBY
  s.version                 =   DcPages.version
  s.authors                 =   ["orangenwerk", "2strange", "marcosebald"]
  s.email                   =   "web@orangenwerk.com"
  s.homepage                =   "http://orangenwerk.com"
  s.description             =   "DressCode-CMS .. by orangenwerk .. may be released in 2012"
  
  s.files                   =   Dir['app/**/*', 'config/**/*', 'db/**/*', 'features/**/*', 'lib/**/*', 'spec/**/*']
  s.require_path            =   'lib'
  s.requirements            <<  'none'
  
  
  s.name                    =   'dc_pages'
  s.rubyforge_project       =   'dc_pages'
  s.summary                 =   'DressCode - Pages-Functionality'
  
  
  
  
  # => View-Helper  
  s.add_dependency( 'acts_as_list',   '>= 0.1.2' )
  s.add_dependency( 'kaminari',       '~> 0.12.4' )
  s.add_dependency( 'truncate_html',  '~> 0.5.1' )
  
  # => to compress js & css
  s.add_dependency( 'yui-compressor', '~> 0.9.6' )
  
  # => maybe add Draper / Active_Presenter ???
  
  
  
end
