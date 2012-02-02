# encoding: utf-8
class Categorize < ActiveRecord::Base
  
  belongs_to :category
  belongs_to :target, :polymorphic => true
  
  before_create :kill_doubles
  
  private

    def kill_doubles
      Categorize.where(:category_id => self.kategorie_id, :target_id => self.target_id, :target_type => self.target_type).each do |duble|
        duble.destroy
      end
    end
  
end
