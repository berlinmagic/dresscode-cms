# encoding: utf-8
class DcPagePass
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
        
        return true if @passthru.include?(request.fullpath)
        # => !request.fullpath.start_with?('/auth/')
        false
    end
end