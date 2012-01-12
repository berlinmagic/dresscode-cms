require 'RMagick' 
module Dragonfly 
  module Processing 
    class TiledTextWatermarkProcessor 
      include Dragonfly::RMagick::Utils 
      include Dragonfly::Configurable 
      configurable_attr :use_filesystem, true 
      def add_tiled_text(temp_object, opts={}) 
        text        =   opts[:text]       ||  'fineline-CMS'
        color       =   opts[:color]      ||  'f3f2f2'
        opacity     =   opts[:opacity]    ||  42
        font_size   =   opts[:font_size]  ||  18
        rotate      =   opts[:rotate]     ||  0
        tile        =   [1, 4, 9, 16].include?(opts[:tile].to_i) ? opts[:tile].to_i : 1
        
        rmagick_image(temp_object) do |image|
          
          if tile == 16
            width   =   (image.columns / 4).to_i
            height  =   (image.rows / 4).to_i
          elsif tile == 9
            width   =   (image.columns / 3).to_i
            height  =   (image.rows / 3).to_i
          elsif tile == 4
            width   =   (image.columns / 2).to_i
            height  =   (image.rows / 2).to_i
          else
            width   =   image.columns
            height  =   image.rows
          end
          
          wm = Magick::Image.read("xc:none") { self.size = "#{width}x#{height}" }.first

          # Draw "RMagick" in semi-transparent text on the transparent image.
          gc = Magick::Draw.new
          gc.fill "##{ color }#{ opacity }"
          gc.font_weight Magick::BoldWeight
          gc.font_size font_size
          gc.rotate rotate
          gc.gravity Magick::CenterGravity
          gc.text 0, 0, "#{text}"
          gc.draw wm
          # Read the background image.

          # Composite the tile image over the background image.
          image.composite_tiled! wm
          
        end 
      end 
    end 
  end 
end