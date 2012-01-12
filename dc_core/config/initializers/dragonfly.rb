# encoding: utf-8
  # => Dragonfly
# =>   require 'rack/cache'
# =>   require 'dragonfly/rails/images'
# =>   require 'dragonfly-rmagick'
# =>   require 'image_processors/watermark_processor'
# =>   require 'image_processors/tiled_text_watermark_processor'
# =>   require 'image_processors/fade_processor' 
# =>   require 'image_processors/polaroid_processor' 
# =>   require 'image_processors/extend_processor'
# => 
# =>   app = Dragonfly[:images]
# =>   app.configure_with(:rails)
# =>   app.configure_with(:rmagick) 
# =>   
# =>   # app.configure_with(:imagemagick)  # => Changed to use own processors
# =>   
# =>   app.define_macro(ActiveRecord::Base, :image_accessor)
# => 
# =>   # => special-image-processors (need rmagick)
# =>   
# =>   app.processor.register(Dragonfly::Processing::WatermarkProcessor) 
# =>   app.processor.register(Dragonfly::Processing::TiledTextWatermarkProcessor) 
# =>   app.processor.register(Dragonfly::Processing::PolaroidProcessor) 
# =>   app.processor.register(Dragonfly::Processing::FadeProcessor)
# =>   app.processor.register(Dragonfly::Processing::ExtendProcessor)


require 'rack/cache'
require 'dragonfly/rails/images'


app = Dragonfly[:images]
app.configure_with(:imagemagick)
app.configure_with(:rails)

app.define_macro(ActiveRecord::Base, :image_accessor)