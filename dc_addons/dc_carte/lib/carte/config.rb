module DC::Carte
  class Config < DC::Config
    class << self
      def instance
        return nil unless ActiveRecord::Base.connection.tables.include?('configurations')
        CarteConfiguration.find_or_create_by_name("carte configuration")
      end
    end
  end
end