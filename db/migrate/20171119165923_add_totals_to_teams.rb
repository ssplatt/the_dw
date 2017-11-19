class AddTotalsToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :season_total, :float
    add_column :teams, :s1_total, :float
    add_column :teams, :s2_total, :float
    add_column :teams, :s3_total, :float
    add_column :teams, :s4_total, :float
    add_column :teams, :s5_total, :float
    add_column :teams, :playoff_total, :float
  end
end
