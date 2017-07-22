class Division < ApplicationRecord
  belongs_to :league
  has_many :lineups
  
  def random_name
    self.name = Faker::Team.state
  end
end
