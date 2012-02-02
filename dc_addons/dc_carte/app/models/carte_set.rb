# encoding: utf-8
class CarteSet < ActiveRecord::Base
  
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  belongs_to :carte_entry
  belongs_to :target, :polymorphic => true
  
  # before_create :kill_doubles
  
  private

    def kill_doubles
      CarteSet.where( :carte_entry_id => self.carte_entry_id, :target_id => self.target_id, :target_type => self.target_type ).each do |duble|
        duble.destroy
      end
    end
  
end
