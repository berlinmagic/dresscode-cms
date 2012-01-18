# encoding: utf-8
class Pipe::StylezController < ApplicationController
  
  include DcStylesHelp
  
  layout 'pipe/style'
  
  # Public styles named by theme, so can be cached 
  def public
    
  end
  
  # System Styles, wan´t change per theme
  def dc_style
    
  end
  
  # Librarys .. to load and compress single or bundled style (eg. for fallback)
  def library
    
  end
  
  
end