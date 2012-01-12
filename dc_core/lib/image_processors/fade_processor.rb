require 'RMagick'

module Dragonfly 
  module Processing 
    class FadeProcessor 
      include Dragonfly::RMagick::Utils 
      include Dragonfly::Configurable 
      configurable_attr :use_filesystem, true
      
      FADER_STYLEZ = %w(horizontal vertical all)
      
      def fader(temp_object, opts={})
        
        size = opts[:size]    ||  50
        style = opts[:style]   ||  FADER_STYLEZ[0]
        x_position = (style == 'all') || (style == 'horizontal') ? size / 2 : 0
        y_position = (style == 'all') || (style == 'vertical') ? size / 2 : 0
        x_blur = (style == 'all') || (style == 'horizontal') ? size : 0
        y_blur = (style == 'all') || (style == 'vertical') ? size : 0
        rmagick_image(temp_object) do |image|
          this_pic = Magick::Image.read(temp_object.path).first
          mask = Magick::Image.new(this_pic.columns, this_pic.rows) {self.background_color = 'black'}
          form = Magick::Draw.new
          form.stroke('white')
          form.fill('white')
          form.rectangle(x_position,y_position, "#{this_pic.columns - x_position}", "#{this_pic.rows - y_position}" )
          form.draw(mask)
          mask = mask.blur_image(y_blur, x_blur)
          # => this_pic.alpha(ActivateAlphaChannel)      # =>  klappt nicht ?!  .. bild muss ein png sein !
          # => this_pic.matte = true      # Ensure the ballerina image's opacity channel is enabled. >>> macht gif = schlechte Quali !
          mask.matte = false
          
          this_pic = this_pic.composite(mask, Magick::CenterGravity, Magick::CopyOpacityCompositeOp)
          image = this_pic
          # => checkerboard = Magick::Image.read('pattern:checkerboard') {self.size = "#{this_pic.columns}x#{this_pic.rows}"}
          # => vignette = wm.composite(this_pic, Magick::CenterGravity, Magick::OverCompositeOp)
          # => image = vignette
          
        end
        
      end 
      
      def side_fade(temp_object, opts={})
        
        size = opts[:size]    ||  50
        
        
        rmagick_image(temp_object) do |image|
          
          this_pic  = Magick::Image.read(temp_object.path).first
          
          rows        = this_pic.rows
          cols        = this_pic.columns
          opac        = "#fff"
          trans       = "#000"

          right_fill  = Magick::GradientFill.new(0, 0, 0, size, trans, opac)
          left_fill   = Magick::GradientFill.new(0, 0, 0, size, opac, trans)
          vr          = Magick::Image.new(size, rows, right_fill)
          vl          = Magick::Image.new(size, rows, left_fill)
          mask        = Magick::Image.new(cols, rows);
          mask        = mask.composite(vr, Magick::WestGravity, Magick::OverCompositeOp)
          mask        = mask.composite(vl, Magick::EastGravity, Magick::OverCompositeOp)

          
          this_pic    = this_pic.composite(mask, Magick::WestGravity, Magick::CopyOpacityCompositeOp)
          
          image       = this_pic
          
        end
        
      end
      
    end 
  end 
end


