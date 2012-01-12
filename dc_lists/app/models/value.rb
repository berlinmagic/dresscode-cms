# encoding: utf-8
class Value < ActiveRecord::Base
  
  belongs_to :value_list
  
  acts_as_list
  
  default_scope :order => "position ASC"
  
  before_save :make_position
  
  
  validates :content, :presence => true
  
  private

    def make_position
      unless new_record?
        return unless prev_position = Value.find(self.id).position
        unless self.position.nil?
          if prev_position > self.position
            Value.update_all("position = position + 1", ["? <= position AND position < ?", self.position, prev_position])
          elsif prev_position < self.position
            Value.update_all("position = position - 1", ["? < position AND position <= ?", prev_position,  self.position])
          end
        end
      end
    end
    
  
  
end