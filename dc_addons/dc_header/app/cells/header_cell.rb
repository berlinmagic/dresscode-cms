class HeaderCell < Cell::Rails
  include GlobalBase
  include DcStylesHelp
  # include CacheBase
  
  # cache :fader do |cell, options|
  #     "#{ options[:header].id.to_s }"
  # end
  # cache :fader_js do |cell, options|
  #     "#{ options[:header].id.to_s }"
  # end
  
  #cache :fader
  #cache :fader_js

  def display(args)
    @page = args[:page]
    if @page
      if @page.header
        @header = @page.header
      else
        @header = Header.first # if DC::Header::Config[:generell_show_header]
      end
    end
   render
  end
  
  def script(args)
    @page = args[:page]
    if @page
      if @page.header
        @header = @page.header
      else
        @header = Header.first # if DC::Header::Config[:generell_show_header]
      end
    end
    render
  end
  
  def type_fader(args)
    @page = args[:page]
    @header = args[:header]
    render
  end
  
  def type_fader_js(args)
    @page = args[:page]
    @header = args[:header]
    render
  end
  
  def type_accordion(args)
    @page = args[:page]
    @header = args[:header]
    render
  end
  
  def type_accordion_js(args)
    @page = args[:page]
    @header = args[:header]
    render
  end

end
