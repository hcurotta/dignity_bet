class CreateBets < ActiveRecord::Migration
  def change
    
    create_table :bets do |t|
      t.integer :owner
      t.integer :challenger
      t.string :challenge
      t.string :win_status
      t.string :lose_status
      t.string :status

      t.timestamps
    end
  end
end
