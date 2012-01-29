# encoding: utf-8
class Header < ActiveRecord::Base
  
  HEADER_TYPES    = ['fader', 'slider', 's3_slider', 'accordion']
  
  BG_STYLES       = ['farbe', 'verlauf', 'bild', 'bild_farbe', 'bild_verlauf', 'none']
  
  X_VALUES        = %W(left center right)
  Y_VALUES        = %W(top center bottom)
  REPEAT_VALUES   = %w(xrepeat yrepeat repeat norepeat)
  
  
  has_many :pages
  
  has_many :attachments, :class_name => "Attachment", :as => :target
  has_many :data_files, :through => :attachments
  
  has_one :background, :through => :attachments, :conditions => ["attachment.primary = ?", true], :source => :attachments
  
end
