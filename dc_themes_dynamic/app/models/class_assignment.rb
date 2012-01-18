class ClassAssignment < ActiveRecord::Base
  
  # =====> A S S O Z I A T I O N S <======================================================== #
  belongs_to :target, :polymorphic => true
  belongs_to :style_class
  
end
