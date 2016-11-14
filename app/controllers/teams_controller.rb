class TeamsController < ApplicationController
  before_action :correct_team,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  def show
    @team = Team.find(params[:id])
    @league = @team.league
    store_team
    store_league
  end
  
  def edit
    @team = Team.find(params[:id])
  end
  
  def update
    @team = Team.find(params[:id])
    if @team.update_attributes(team_params)
      flash[:success] = "Team updated"
      redirect_to @team
    else
      render 'edit'
    end
  end
  
  def new
    @league ||= current_league
    if @league.num_teams < @league.num_teams + 1
      @team = @league.teams.new
    else
      flash[:danger] = "League full"
      redirect_to @league
    end
  end
  
  def create
    @team = Team.new(team_params)
    @team.league_id ||= current_league.id
    @team.user_id ||= current_user.id
    @team.random_name
    @team.division = @team.league.divisions.first

    if @team.save
      @team.create_invite_digest
      #@team.send_invite_email
      flash[:info] = "Invite created"
      redirect_to @league
    else
      flash.now[:danger] = "User or League not found"
      render 'new'
    end
  end
  
  private

    def team_params
      params.require(:team).permit(:name, :user_id, :team_id, :league_id, :division_id, :logo)
    end
    
    # Confirms the correct team.
    def correct_team
      @team = Team.find(params[:id])
      redirect_to(@team) unless current_team?(@team) || current_user.admin?
    end
  
end
