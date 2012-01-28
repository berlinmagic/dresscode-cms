module DC::Contact
  class Config < DC::Config
    class << self
      def instance
        return nil unless ActiveRecord::Base.connection.tables.include?('configurations')
        ContactConfiguration.find_or_create_by_name("Contact configuration")
      end
    end
  end
end