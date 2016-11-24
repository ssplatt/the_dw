class AddScoresToLineups < ActiveRecord::Migration[5.0]
  def change
    add_column :lineups, :qb_score, :float, default: 0
    add_column :lineups, :rb1_score, :float, default: 0
    add_column :lineups, :rb2_score, :float, default: 0
    add_column :lineups, :wr1_score, :float, default: 0
    add_column :lineups, :wr2_score, :float, default: 0
    add_column :lineups, :total_score, :float, default: 0
  end
end
