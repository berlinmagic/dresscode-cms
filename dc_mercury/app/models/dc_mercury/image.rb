class DcMercury::Image < ActiveRecord::Base

  self.table_name = :dc_mercury_images

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  delegate :url, :to => :image

  def serializable_hash(options = nil)
    options ||= {}
    options[:methods] ||= []
    options[:methods] << :url
    super(options)
  end

end
