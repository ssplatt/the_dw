require 'test_helper'

class TeamsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @team       = teams(:one)
    @other_team = teams(:two)
  end
  
end
