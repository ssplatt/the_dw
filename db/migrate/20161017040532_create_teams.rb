class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.text :name
      t.text :logo
      t.boolean :is_commissioner, default: false
      t.references :league, foreign_key: true
      t.references :user, foreign_key: true
      t.references :division, foreign_key: true

      t.timestamps
    end
    add_index :teams, :name
  end
end
