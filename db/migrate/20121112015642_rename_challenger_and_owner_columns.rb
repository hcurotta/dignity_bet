class RenameChallengerAndOwnerColumns < ActiveRecord::Migration
  def change
    rename_column :bets, :challenger, :challenger_id
    rename_column :bets, :owner, :owner_id
  end
end
