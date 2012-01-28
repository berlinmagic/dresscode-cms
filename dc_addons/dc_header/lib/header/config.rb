module DC::Header
  class Config < DC::Config
    class << self
      def instance
        return nil unless ActiveRecord::Base.connection.tables.include?('configurations')
        HeaderConfiguration.find_or_create_by_name("header configuration")
      end
    end
  end
end