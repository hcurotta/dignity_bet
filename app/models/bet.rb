class Bet < ActiveRecord::Base
  attr_accessible :challenge, :challenger_id, :lose_status, :owner_id, :status, :win_status
  
  belongs_to :owner, :class_name => 'User', :foreign_key => :owner_id
  belongs_to :challenger, :class_name => 'User', :foreign_key => :challenger_id
  
end
