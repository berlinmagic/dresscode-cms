module DC::Tags
  class Config < DC::Config
    class << self
      def instance
        return nil unless ActiveRecord::Base.connection.tables.include?('configurations')
        TagsConfiguration.find_or_create_by_name("tags configuration")
      end
    end
  end
end