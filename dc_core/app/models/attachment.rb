# encoding: utf-8
class Attachment < ActiveRecord::Base
  
  # Attachment is the polymorphic association for DataFile
  
  
  scope :prime,         where( :primary => true )
  scope :norm,          where( :primary => false )
  
  
  # =>  Associations:     <============================================================================= #
  belongs_to :data_file
  belongs_to :target, :polymorphic => true
  
  
  # =>  CallBack´s:       <============================================================================= #
  # => before_create :kill_doubles
  
  
  # =>  P R I V A T E     <============================================================================= #
  private

    def kill_doubles
      Attachment.where( 
          :data_file_id   => self.data_file_id, 
          :target_id      => self.target_id, 
          :target_type    => self.target_type 
      ).each do |duble|
        duble.destroy
      end
    end
  
end