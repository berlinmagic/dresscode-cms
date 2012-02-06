# encoding: utf-8
class DcCartePass
    def initialize
      
        @carte_pass = []
        @carte_link = ''
        
        if Page.table_exists?
          
          if Page.where("system_name = ? AND deleted_at = ?", 'carte', nil).count > 0
            
            @carte_link = Page.where("system_name = ? AND deleted_at = ?", 'carte', nil).first.link
            @carte_pass << Page.where("system_name = ? AND deleted_at = ?", 'carte', nil).first.link
            
            if Carte.table_exists?
              Carte.all.each do |c|
                @carte_pass << "#{ @carte_link }/#{ c.name.strip.downcase }"
              end
            end
          
            if SubCarte.table_exists?
              SubCarte.all.each do |sc|
                @carte_pass << "#{ @carte_link }/#{ sc.name.strip.downcase }"
              end
            end
            
          end

        end

    end

    def matches?(request)
        
        # => return true if request.fullpath.start_with?("#{@passthru}/by_date")
        # => return true if request.fullpath.start_with?("#{@passthru}/by_tag")
        # => return true if request.fullpath.start_with?("#{@passthru}/page")
        
        return true if @carte_pass.include?(request.fullpath)
        # => !request.fullpath.start_with?('/auth/')
        false
    end
end