module DC::PicSlider
  class Config < DC::Config
    class << self
      def instance
        return nil unless ActiveRecord::Base.connection.tables.include?('configurations')
        PicSliderConfiguration.find_or_create_by_name("pic_slider configuration")
      end
    end
  end
end