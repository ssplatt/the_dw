class League < ApplicationRecord
  has_many :teams
  has_many :divisions
  has_many :lineups, through: :teams
end
