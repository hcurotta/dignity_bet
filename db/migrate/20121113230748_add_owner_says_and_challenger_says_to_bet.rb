class AddOwnerSaysAndChallengerSaysToBet < ActiveRecord::Migration
  def change
    add_column :bets, :owner_says, :string
    add_column :bets, :challenger_says, :string
  end
end
