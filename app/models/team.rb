class Team < ApplicationRecord
  belongs_to :league
  belongs_to :user
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
  
  def seed_lineups
    (1..17).each do |week|
      if not self.lineups.find_by(week: week)
        lu = self.lineups.new
        lu.week = week
        lu.division = self.league.divisions.first
        lu.save
      end
    end
  end
  
  # Sets the invitation attributes.
  def create_invite_digest
    self.invite_digest = Team.new_token
    update_attribute(:invite_digest,  Team.digest(invite_digest))
  end
  
  # calculate session and season totals
  def calc_totals
    # init for fresh totals
    self.s1_total = 0
    self.s2_total = 0
    self.s3_total = 0
    self.s4_total = 0
    self.s5_total = 0
    self.playoff_total = 0
    self.season_total = 0
    
    self.lineups.each do |lu|
      if lu.week.between?(1, 4)
        # session 1
        self.s1_total += lu.total_score
      elsif lu.week.between?(5, 8)
        # session 2
        self.s2_total += lu.total_score
      elsif lu.week.between?(9, 12)
        # session 3
        self.s3_total += lu.total_score
      elsif lu.week.between?(13, 16)
        # session 4
        self.s4_total += lu.total_score
      elsif lu.week.between?(17, 20)
        # session 5
        self.s5_total += lu.total_score
        
        # playoffs
        if lu.week.between?(18, 20)
          self.playoff_total += lu.total_score
        end
      end
      
      self.season_total += lu.total_score
      self.save
    end
  end
  
  private
    
end
