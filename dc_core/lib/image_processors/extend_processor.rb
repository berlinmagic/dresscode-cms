# Outdated .. need to be refactored in ImageMagick !

# => require 'RMagick'
# => module Dragonfly 
# =>   module Processing 
# =>     class ExtendProcessor 
# =>       include Dragonfly::RMagick::Utils 
# =>       include Dragonfly::Configurable 
# =>       configurable_attr :use_filesystem, true 
# =>       def blowup(temp_object, opts={}) 
# => 
# =>         rmagick_image(temp_object) do |image|
# =>           
# =>           # => image = image.write('PNG')
# =>            
# =>           width   =   opts[:width].to_i  || 3000
# =>           height  =   opts[:height].to_i || 1500
# =>           
# =>           width   = (image.columns * 3) if image.columns > width
# =>           height   = (image.rows * 3) if image.rows > height
# =>           
# =>           x_off   =   (width - image.columns) / -2
# =>           y_off   =   (height - image.rows) / -2
# =>           
# =>           image.background_color = "rgba(0,0,0,.0)"
# =>           
# =>           image.extent(width, height, x_off, y_off)
# =>           
# =>         end 
# =>       end 
# =>     end 
# =>   end 
# => end

