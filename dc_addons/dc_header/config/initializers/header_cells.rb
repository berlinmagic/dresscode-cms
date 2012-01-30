Cell::Base.prepend_view_path( File.join("#{DcHeader::Engine.config.root}", "app", "cells") )
Cell::Base.prepend_view_path( File.join("#{DcHeader::Engine.config.root}", "app", "views") )