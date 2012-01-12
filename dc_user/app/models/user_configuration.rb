# encoding: utf-8
class UserConfiguration < Configuration
  TIMES = ['minutes', 'hours', 'days', 'weeks']
  LOCK_STRATEGY = [:failed_attempts, :none]
  UNLOCK_STRATEGY = [:email, :time, :both, :none]

  # this keys works for localhost
  preference :mailer_sender, :string, :default => 'cms@orangenwerk.com'
  
  preference :allow_nick_name, :boolean, :default => false
  
  
  preference :invite_for, :integer, :default => '2'
  preference :invite_for_period, :string, :default => TIMES[3]
  
  preference :confirm_within, :integer, :default => '3'
  preference :confirm_within_period, :string, :default => TIMES[2]
  
  preference :remember_for, :integer, :default => '2'
  preference :remember_for_period, :string, :default => TIMES[3]
  
  preference :password_length_from, :integer, :default => '6'
  preference :password_length_to, :integer, :default => '20'
  
  preference :timeout_in, :integer, :default => '180'
  preference :timeout_in_period, :string, :default => TIMES[0]
  
  preference :maximum_attempts, :integer, :default => '5'
  
  preference :unlock_in, :integer, :default => '5'
  preference :unlock_in_period, :string, :default => TIMES[0]
  
  preference :lock_strategy, :string, :default => LOCK_STRATEGY[0]
  preference :unlock_strategy, :string, :default => UNLOCK_STRATEGY[2]

end