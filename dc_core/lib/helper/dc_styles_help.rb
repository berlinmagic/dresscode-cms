# encoding: utf-8
module DcStylesHelp
  module InstanceMethods
    require "yui/compressor"
    
    def all_border_radius(radius=nil)
        radius = radius.blank? ? 'none' : radius
        border_radius( radius, radius, radius, radius )
    end
    
    def border_radius(lt=nil,rt=nil,rb=nil,lb=nil)
        lt = lt.blank? || lt == 'none' ? 0 : lt
        rt = rt.blank? || rt == 'none' ? 0 : rt
        rb = rb.blank? || rb == 'none' ? 0 : rb
        lb = lb.blank? || lb == 'none' ? 0 : lb
        "  -khtml-border-radius: 	  #{ lt } #{ rt } #{ rb } #{ lb };
           -webkit-border-radius: 	#{ lt } #{ rt } #{ rb } #{ lb }; 
        	 -moz-border-radius: 	    #{ lt } #{ rt } #{ rb } #{ lb }; 
        	 -o-border-radius: 		    #{ lt } #{ rt } #{ rb } #{ lb }; 
        	 -ms-border-radius: 		  #{ lt } #{ rt } #{ rb } #{ lb };
        	 border-radius: 			    #{ lt } #{ rt } #{ rb } #{ lb };  
        	 behavior: url(/stylesheets/border-radius.htc);  "
    end

    def vertical_gradient(top,bottom=nil)
        bottom = bottom.blank? ? top : bottom
        " background: #{ top };
          background: -khtml-gradient(linear, left top, left bottom, from(#{ top }), to(#{ bottom }));
      	  background: -moz-linear-gradient(top, #{ top } 0%,  #{ bottom } 100%);
      	  background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#{ top }), color-stop(100%,#{ bottom }));
      	  background: -webkit-linear-gradient(top, #{ top } 0%,#{ bottom } 100%);
      	  background: -o-linear-gradient(top, #{ top } 0%,#{ bottom } 100%);
      	  background: -ms-linear-gradient(top, #{ top } 0%,#{ bottom } 100%);
      	  filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#{ top }', endColorstr='#{ bottom }',GradientType=0 );
      	  background: linear-gradient(top, #{ top } 0%,#{ bottom } 100%);    "
    end
    
    def background_gradient(orientation=nil, pts={})
        way = !orientation.blank? && %w(horizontal vertikal radial diagonal1 diagonal2).include?(orientation) ? orientation : 'vertikal'  
        werte = []
        pts.each { |key, value| [ werte[key] = value ] }
        top = werte.first
        bottom = werte.last
        ms_gradient = false
        ms_way = 0
        t = 'linear'
        if way == 'horizontal'
          x = 'left 50%'
          y = 'right 50%'
          z = 'left'
          ms_gradient = true
          ms_way = 1
        elsif way == 'diagonal1'
          x = 'left top'
          y = 'right bottom'
          z = 'left top'
        elsif way == 'diagonal2'
          x = 'left bottom'
          y = 'right top'
          z = 'left bottom'
        elsif way == 'radial'
          t = 'radial'
          x = '50% 50%, 1'
          y = '50% 50%, 100'
          z = '50% 50%, circle cover'
        else
          x = '50% top'
          y = '50% bottom'
          z = 'top'
          ms_gradient = true
        end
        wk_werte = ""
        std_werte = ""
        werte.each_with_index do |w,i|
          unless w.blank?
            std_werte = std_werte + ", #{w} #{i}%"
            unless (i == 0) || (i == 100)
              wk_werte = wk_werte + ", color-stop(#{i}%, #{w})"
            end
          end
        end
        std_bg = "background: #{top};"
        webkit = "background-image: -webkit-gradient(#{t}, #{x}, #{y}, from(#{top}), to(#{bottom})" + wk_werte + ");"
        khtml = "background-image: -khtml-gradient(#{t}, #{x}, #{y}, from(#{top}), to(#{bottom})" + wk_werte + ");"
        wkit = "background-image: -webkit-#{t}-gradient(#{z}" + std_werte + ");"
        moz = "background-image: -moz-#{t}-gradient(#{z}" + std_werte + ");"
        o = "background-image: -o-#{t}-gradient(#{z}" + std_werte + ");"
        ms = "background-image: -ms-#{t}-gradient(#{z}" + std_werte + ");"
        all = "background-image: #{t}-gradient(#{z}" + std_werte + ");"
        ms_std = "filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#{ top }', endColorstr='#{ bottom }',GradientType=#{ms_way} );"
        
        " #{std_bg} 
          #{webkit}
          #{khtml}
          #{wkit}
          #{moz}
          #{o}
          #{ms}
          #{ms_std if ms_gradient}
          #{all} "
    end
    
    def box_shadow(shadow=nil)
        shadow = shadow.blank? ? 'none' : shadow
        "-o-box-shadow:       #{ shadow };
         -webkit-box-shadow:  #{ shadow };
         -moz-box-shadow:     #{ shadow };
         -ms-box-shadow:      #{ shadow };
         -khtml-box-shadow:   #{ shadow };
         box-shadow:          #{ shadow };"
    end
    
    def text_shadow(shadow=nil)
        shadow = shadow.blank? ? 'none' : shadow
        "text-shadow: #{ shadow };"
    end
    
    def opacity( opacity )
      opacity = opacity.to_i
      if opacity
        if opacity > 1
          if opacity == 100
            opac = 1.0
            opaz = 100
          else
            opac = "0.#{ opacity }".to_f
            opaz = opacity.to_i
          end
        else
          if opacity == 1
            opac = 1.0
            opaz = 100
          else
            opac = "#{ opacity }".to_f
            opaz = opacity.to_i * 100
          end
        end
      end
      " opacity: #{opac};
        -moz-opacity: #{opac};
        -webkit-opacity: #{opac};
        -ms-filter: 'progid:DXImageTransform.Microsoft.Alpha(Opacity=#{ opaz })';
        filter: alpha(opacity=#{ opaz }); "
    end
    

    def css_minify(css)
      compressor = YUI::CssCompressor.new
      if DC::Config[:compress_stylez]
        this_css = compressor.compress(css)
      else
        this_css = css
      end
      # => this_css = compressor.compress(css)
      this_css
    end
    
    def js_minify(js)
      compressor = YUI::JavaScriptCompressor.new(:optimize => true, :preserve_semicolons => false, :munge => true)
      if DC::Config[:compress_scriptz]
        this_js = compressor.compress(js)
      else
        this_js = js
      end
      # => this_js = compressor.compress(js)
      this_js
    end
    
    
  end ### =>  End of InstanceMethods

  def self.included(receiver)
    #receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    #receiver.send :helper, 'fine_form'
    #receiver.send :helper, 'fine_styler'
    receiver.send :helper_method, 'all_border_radius'
    receiver.send :helper_method, 'border_radius'
    receiver.send :helper_method, 'vertical_gradient'
    receiver.send :helper_method, 'background_gradient'
    receiver.send :helper_method, 'box_shadow'
    receiver.send :helper_method, 'text_shadow'
    receiver.send :helper_method, 'opacity'
    receiver.send :helper_method, 'css_minify'
    receiver.send :helper_method, 'js_minify'
  end
  
end