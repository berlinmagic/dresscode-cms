# encoding: utf-8
class Tagging < ActiveRecord::Base
  
  belongs_to :tag
  belongs_to :target, :polymorphic => true
  
  before_create :kill_doubles
  
  private

    def kill_doubles
      Tagging.where( :tag_id => self.tag_id, :target_id => self.target_id, :target_type => self.target_type ).each do |duble|
        duble.destroy
      end
    end
  
end
