class Team < ApplicationRecord
  belongs_to :league
  belongs_to :user
  belongs_to :division
  has_many :lineups
  
  # Returns the hash digest of the given string.
  def Team.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # Returns a random token.
  def Team.new_token
    SecureRandom.urlsafe_base64
  end
  
  # User accepts invite, claims team
  def claim
    update_attribute(:claimed,    true)
    update_attribute(:claimed_at, Time.zone.now)
  end
  
  def random_name
    self.name = Faker::Team.name
  end
  
  # Sets the invitation attributes.
  def create_invite_digest
    self.invite_digest = Team.new_token
    update_attribute(:invite_digest,  Team.digest(invite_digest))
  end
  
  private
    
end