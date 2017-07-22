require 'test_helper'

class TeamsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @team       = teams(:one)
    @other_team = teams(:two)
  end
  
  test "should redirect index when not logged in" do
    get teams_path
    assert_redirected_to login_url
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  test "should redirect update when not logged in" do
    patch team_path(@team), params: { team: { name: @team.name } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Team.count' do
      delete team_path(@team)
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'Team.count' do
      delete team_path(@team)
    end
    assert_redirected_to root_url
  end
  
end
