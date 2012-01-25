# encoding: utf-8
module IconHelper
  
  #   #   #   #   #   #   #   #   #   #   #   #   # 
  # > Dresscode Icons
  #   #   #   #   #   #   #   #   #   #   #   #   #
  
  def dc_icon(options = {})
    options.assert_valid_keys(  :icon,  :blur,  :color,   :size,  :aktion )
    options.reverse_merge! :icon    => 1        unless options.key? :icon       # => 1 - 90  /  1 - 25
    options.reverse_merge! :blur    => 1.0      unless options.key? :blur       # => 0.01 - 1.0  /  01 - 100
    options.reverse_merge! :color   => 'dunkel' unless options.key? :color      # => 'dunkel'  /  'hell'
    options.reverse_merge! :size    => 18       unless options.key? :size       # => 18 / 24 / 32* / 48*
    options.reverse_merge! :aktion  => false    unless options.key? :aktion     # => 'std'  /  'aktion'  =>  normal / groß
    opt_pix = [18, 24, 32, 48]
    akt_pix = [32, 48]
    size = opt_pix.include?(options[:size].to_i) ? options[:size].to_i : 18
    aktion = ( options[:aktion] && options[:icon].to_i <= 25 && options[:icon].to_i >= 1 && akt_pix.include?(size) ) ? true : false
    icon = options[:icon] <= 90 && options[:icon].to_i >= 1 ? options[:icon].to_i : 1
    size2 = aktion ? ( size + size / 4 ) : size
    color = %w(dunkel hell).include?(options[:color]) ? options[:color] : 'dunkel'
    top = size * (icon - 1)
    opac = 1.0
    if options[:blur]
      if options[:blur].to_f > 1
        opac = ( options[:blur] == 100 ) ? 1.0 : ( opac * "0.#{options[:blur].to_f}".to_f )
      else
        opac = opac * "#{options[:blur].to_f}".to_f
      end
    end
    raw( "<div class='dresscode-Icon #{ color }' style='background: transparent url(/images/iconsets/stripe_#{size}x#{size2}.png) -#{ color == 'dunkel' ? size2 : 0 }px -#{top}px no-repeat; width: #{size2}px; height: #{size}px; opacity: #{ opac.to_s };'></div>" )
  end
  
  def dc_admin_head_icon( icon )
    dc_icon( :icon => icon, :size => 32, :color => 'hell' )
  end
  
  def dc_footer_icon( icon )
    dc_icon( :icon => icon, :size => 32, :color => 'hell' )
  end
  
  def dc_subfooter_icon( icon )
    dc_icon( :icon => icon, :size => 18, :color => 'hell' )
  end

end