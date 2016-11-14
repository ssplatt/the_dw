class CreateLeagues < ActiveRecord::Migration[5.0]
  def change
    create_table :leagues do |t|
      t.text :name
      t.integer :num_teams, default: 12
      t.integer :num_divisions, default: 1
      t.integer :season, default: 2016

      t.timestamps
    end
    add_index :leagues, :name
  end
end
