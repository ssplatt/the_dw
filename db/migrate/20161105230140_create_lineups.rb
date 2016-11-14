class CreateLineups < ActiveRecord::Migration[5.0]
  def change
    create_table :lineups do |t|
      t.integer :qb_id
      t.integer :rb1_id
      t.integer :rb2_id
      t.integer :wr1_id
      t.integer :wr2_id
      t.integer :week
      t.references :team, foreign_key: true

      t.timestamps
    end
  end
end
