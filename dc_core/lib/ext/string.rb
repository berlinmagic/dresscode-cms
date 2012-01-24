# encoding: utf-8
# => require 'iconv'
String.class_eval do
  
  def is_integer?
    begin
      Integer(self.to_s)
      return true
    rescue ArgumentError
      return false
    end
  end
  
  def rb_mojo
    if RUBY_VERSION.match(/1.8.?/)
      "Ruby @ godold 1.8.x".strip
    else
      "Ruby @ 1.9.x".strip
    end
  end
  
  
  def to_slash
    "#{self}".strip.index('/') == 0 ? "#{self}".strip : '/' + "#{self}".strip
  end
  
  def to_utf
    # => ::Iconv.conv('UTF-8//IGNORE', 'UTF-8', self + ' ')[0..-2]
    self.encode("UTF-8").force_encoding("UTF-8")
  end
  
  def to_go
    str = "#{self}".strip
    str = clean_string_de(str)
    str = str.parameterize('_')
    str = str.gsub('-', "_")
  end
  
  def to_anker
    str = "#{self}".strip
    str = clean_string_de(str)
    str = str.parameterize
    str.index('#') == 0 ? str : '#' + str
  end
  
  def to_url
    str = "#{self}".strip
    str = clean_string_de(str)
    str = str.parameterize
    str.to_slash
  end
  
  private
    
    def clean_string_de(str)
      unless RUBY_VERSION.to_f >= 1.9
        str = str.gsub('_', "-")
        str = str.gsub('ä', "ae")
        str = str.gsub('Ä', "Ae")
        str = str.gsub('ö', "oe")
        str = str.gsub('Ö', "Oe")
        str = str.gsub('ü', "ue")
        str = str.gsub('Ü', "Ue")
        str = str.gsub('ß', "ss")
        str = str.gsub('`', "")
        str = str.gsub('´', "")
        str = str.gsub("'", "")
        str = str.gsub("@", " at ")
        str = str.gsub("€", " euro ")
        str = str.gsub("$", " dollar ")
        str = str.gsub("£", " fund ")
        str = str.gsub("¥", " yen ")
        str = str.gsub("§", " paragraph ")
        str = str.gsub("%", " prozent ")
        str = str.gsub("‰", " promille ")
        str = str.gsub("&", " und ")
      else
        str = str.gsub("\u005F", "-")
        str = str.gsub("\u00E4", "ae")
        str = str.gsub("\u00C4", "Ae")
        str = str.gsub("\u00F6", "oe")
        str = str.gsub("\u00D6", "Oe")
        str = str.gsub("\u00FC", "ue")
        str = str.gsub("\u00DC", "Ue")
        str = str.gsub("\u00DF", "ss")
        str = str.gsub("\u0060", "")
        str = str.gsub("\u00B4", "")
        str = str.gsub("\u0027", "")
        str = str.gsub("\u0040", " at ")
        str = str.gsub("\u20AC", " euro ")
        str = str.gsub("\u0024", " dollar ")
        str = str.gsub("\u00A3", " fund ")
        str = str.gsub("\u00A5", " yen ")
        str = str.gsub("\u00A7", " paragraph ")
        str = str.gsub("\u0025", " prozent ")
        str = str.gsub("\u2030", " promille ")
        str = str.gsub("\u0026", " und ")
        # => str = str.gsub("\u", " xxx ")
      end
      return str
    end
  
  
  
end