class AddInviteToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :invite_digest, :string
    add_column :teams, :invite_claimed, :boolean, default: false
    add_column :teams, :invite_claimed_at, :datetime
  end
end
