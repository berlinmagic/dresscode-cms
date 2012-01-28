# Outdated .. need to be refactored in ImageMagick !

# => require 'RMagick' 
# => module Dragonfly 
# =>   module Processing 
# =>     class WatermarkProcessor 
# =>       include Dragonfly::RMagick::Utils 
# =>       include Dragonfly::Configurable 
# =>       configurable_attr :use_filesystem, true 
# =>       def add_watermark(temp_object, opts={}) 
# =>         path = opts[:path]
# =>         tile = [1, 4, 9, 16].include?(opts[:tile].to_i) ? opts[:tile].to_i : 1
# =>         src  = Magick::Image.read(path).first 
# =>         
# =>         rmagick_image(temp_object) do |image|
# =>           
# =>           tiled = tile == 1 ? false : true
# =>           
# =>           exta = path.split('.').last
# =>           jpged = (exta == 'JPG') || (exta == 'jpg') || (exta == 'Jpg') ? true : false
# =>           if jpged
# =>             src.background_color = "rgba(0,0,0,.0)"
# =>             src.opacity = Magick::MaxRGB / 2
# =>           end
# =>           
# =>           if tile == 16
# =>             bg_w = (image.columns / 4).to_i
# =>             bg_h = (image.rows / 4).to_i
# =>           elsif tile == 9
# =>             bg_w = (image.columns / 3).to_i
# =>             bg_h = (image.rows / 3).to_i
# =>           elsif tile == 4
# =>             bg_w = (image.columns / 2).to_i
# =>             bg_h = (image.rows / 2).to_i
# =>           else
# =>             bg_w = image.columns
# =>             bg_h = image.rows
# =>           end
# =>           
# =>           # => p_w = (image.columns / 4 * 3).to_i
# =>           # => p_h = (image.rows / 4 * 3).to_i
# =>           # => scale_w   = p_w < src.columns ? (p_w.to_f / src.columns) : 1
# =>           # => scale_h   = p_h < src.rows ? (p_h.to_f / src.rows) : 1
# =>           # => scale     = scale_w < scale_h ? scale_w : scale_h
# =>           # => big       = src.resize(scale)
# =>           
# =>           scale_sw  = (bg_w * 0.75) < src.columns ? ( (bg_w * 0.75) / src.columns ) : 1
# =>           scale_sh  = (bg_h * 0.75) < src.rows ? ( (bg_h * 0.75) / src.rows ) : 1
# =>           scales    = scale_sw < scale_sh ? scale_sw : scale_sh
# =>           smal      = src.resize(scales)
# =>           
# =>           bg    = Magick::Image.read("xc:none") { self.size = "#{ bg_w }x#{ bg_h }" }.first
# =>           if jpged
# =>             bg.opacity = Magick::MaxRGB / 2
# =>           end
# =>           mark  = bg.composite(smal, Magick::CenterGravity, Magick::OverCompositeOp)
# =>           
# =>           # => if tiled
# =>           # =>   image.composite_tiled mark
# =>           # => else
# =>           # =>   image.composite(big, Magick::CenterGravity, Magick::OverCompositeOp)
# =>           # => end
# =>           
# =>           image.composite_tiled mark
# =>           
# =>         end 
# =>       end 
# =>     end 
# =>   end 
# => end
