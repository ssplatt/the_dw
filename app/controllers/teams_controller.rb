class TeamsController < ApplicationController
  before_action :correct_team,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  def index
    @teams = current_user.teams
  end
  
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
    @user = current_user
    current_league ? @league = current_league : @league = @user.league.first
    
    if @league.num_teams >= @league.teams.count+1
      @team = @league.teams.new
      @team.league_id = @league.id
    else
      flash[:danger] = "League full"
      redirect_to @league
    end
  end
  
  def create
    @team = Team.new(team_params)
    @team.random_name
    @team.division = @team.league.divisions.first

    if @team.save
      @team.seed_lineups
      @team.create_invite_digest
      #@team.send_invite_email
      flash[:info] = "Invite created"
      redirect_to @team.league
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
