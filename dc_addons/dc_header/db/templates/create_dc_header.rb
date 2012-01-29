class CreateDcHeader < ActiveRecord::Migration
  
  def up
    
    create_table( :headers ) do |t|
      t.string        :name                   # => evtl. Überflüssig
      
      t.boolean       :system_stuff,    :default => false             # => save ?
      
      t.string        :header_type,     :default => 'fader'           # => fader  /  slider  /  etc.
      t.string        :stil                                           # => Stil / Style evtl. nützlich ???
      
      t.integer       :width,           :default => 960               # => breite des Headers   ... eh. header_height
      t.integer       :height,          :default => 210               # => höhe des Headers   ... eh. header_height
      
      t.integer       :staytime,        :default => 5                 # => Fader / Slider
      t.integer       :changetime,      :default => 2                 # => Fader
            
      t.boolean       :sort,            :default => false             # => Sortiert / Zufällig
      
      t.boolean       :autoplay,        :default => true              # => Autoplay:  Ja / Nein
      t.boolean       :shownav,         :default => true              # => Navi:  Ja / Nein
      t.string        :navstil,         :default => 'dresscode'       # => Auswahl
      
      t.string        :button_set,      :default => 'dresscode'       # => Auswahl
      
      t.string        :bg_type,         :default => 'verlauf'         # => Auswahl Hingrund => Farbe / Verlauf / Bild / alles
      
      t.string        :bg_color_one,    :default => '003366'          # => Standardfarbe für Hintergrund
      t.string        :bg_color_two,    :default => '00213f'          # => Farbe2 falls Verlauf 
                                                                      
      t.string        :bg_pos_x                                       # => Bild Position horizontal   =>  left / center / right
      t.string        :bg_pos_y                                       # => Bild Position vertical   =>   top / center / bottom
      t.string        :bg_repeat                                      # => Bild-Wiederholung   =>   keine / horizontal / vertikal / beide
      
      t.float         :ratio                                          # => Seitenverhältniss
      
      t.timestamps
    end
    
  end

  def down
    drop_table :headers
  end
  
  
end