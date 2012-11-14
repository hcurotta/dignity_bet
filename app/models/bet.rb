class Bet < ActiveRecord::Base
  attr_accessible :challenge, :challenger_id, :lose_status, :owner_id, :status, :win_status, :owner_says, :challenger_says
  
  belongs_to :owner, :class_name => 'User', :foreign_key => :owner_id
  belongs_to :challenger, :class_name => 'User', :foreign_key => :challenger_id
  
  def role(user)
    if self.owner.id == user.id
      return "owner"
    elsif self.challenger.id == user.id
      return "challenger"
    else 
      return false
    end  
  end
  
  def set_result(user, determination)
    if self.role(user) == "owner"
      self.owner_says = determination
      self.save
    elsif self.role(user) == "challenger"
      self.challenger_says = determination
      self.save
    else
      return false
    end  
  end
  
  def decided?
    if owner_says == "draw" && challenger_says == "draw"
      return true
    elsif (owner_says == "won" && challenger_says == "lost") || (owner_says == "lost" && challenger_says == "won")
      return true
    else
      return false
    end
  end
  
  def winner
    if self.owner_says == "won" && self.challenger_says == "lost"
      return self.owner
    elsif self.owner_says == "lost" && self.challenger_says == "won"
      return self.challenger
    elsif self.owner_says == "draw" && self.challenger_says == "draw"
      return "draw"
    elsif self.owner_says == nil || self.challenger_says == nil
      return "undecided"
    else
      return "disputed"
    end
  end
  
  def other_guy(me)
    if owner == me
      return challenger
    else
      return owner
    end
  end
  
  def result(player)
    if winner == player
      return 'won'
    elsif winner == other_guy(player)
      return 'lost'
    elsif winner == "draw" 
      return 'drew'
    else
      return winner
    end
  end
      
  def post_loser_status
    if decided? && winner != "draw"
      puts other_guy(winner).oauth_token
      losers_facebook = Koala::Facebook::API.new(other_guy(winner).oauth_token)

      if winner = owner
        losers_facebook.put_wall_post(win_status)
      else
        losers_facebook.put_wall_post(lose_status)
      end
    else 
      return false
    end
  end
  
end
