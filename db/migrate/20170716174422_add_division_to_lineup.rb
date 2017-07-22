class AddDivisionToLineup < ActiveRecord::Migration[5.0]
  def change
    add_reference :lineups, :division, foreign_key: true
  end
end
