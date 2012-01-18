# encoding: utf-8
class DcEditPagePass
    def initialize
        @passthru = []
        if Page.table_exists?
          Page.all.each do |x|
            @passthru << x.full_slug
            @passthru << x.slug
          end
        end
    end

    def matches?(request)
        
        return false if request.fullpath.start_with?('/admin/')
        return false if request.fullpath.start_with?('/system/')
        return false if request.fullpath.start_with?('/backups/')
        
        repue = request.fullpath.to_s.gsub(/\/dc\/page/, '').to_slash
        
        return true if @passthru.include?( repue )
        # => !request.fullpath.start_with?('/auth/')
        false
    end
end