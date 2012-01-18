require 'rack'

module Rack
  module DcCache
    def self.release
      "1.0.1"
    end
  end
  autoload :DcStaticCache,              "rack/dc_cache/dc_static_cache"
end