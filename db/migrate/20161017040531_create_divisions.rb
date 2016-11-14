class CreateDivisions < ActiveRecord::Migration[5.0]
  def change
    create_table :divisions do |t|
      t.text :name
      t.references :league, foreign_key: true

      t.timestamps
    end
  end
end
