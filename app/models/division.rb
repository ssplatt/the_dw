class Division < ApplicationRecord
  belongs_to :league
  has_many :teams
  
  def new
  end
  
  def create
  end
  
  def update
  end
  
  def edit
  end
  
  def random_name
    self.name = Faker::Team.state
  end
end
