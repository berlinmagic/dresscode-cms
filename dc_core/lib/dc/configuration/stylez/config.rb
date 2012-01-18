module DC::Stylez
  class Config < DC::Config
    class << self
      def instance
        return nil unless ActiveRecord::Base.connection.tables.include?('configurations')
        StylezConfiguration.find_or_create_by_name("Stylez configuration")
      end
    end
  end
end