class RemoveDivisonFromTeam < ActiveRecord::Migration[5.0]
  def change
    remove_reference :teams, :division
  end
end
