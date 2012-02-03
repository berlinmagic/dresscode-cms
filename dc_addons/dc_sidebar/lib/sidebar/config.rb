module DC::Sidebar
  class Config < DC::Config
    class << self
      def instance
        return nil unless ActiveRecord::Base.connection.tables.include?('configurations')
        SidebarConfiguration.find_or_create_by_name("sidebar configuration")
      end
    end
  end
end