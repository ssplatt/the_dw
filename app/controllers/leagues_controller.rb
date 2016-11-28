class LeaguesController < ApplicationController
  before_action :allowed_user,      only: :show
  before_action :correct_league,    only: [:edit, :update]
  before_action :admin_user,        only: :destroy
  
  def index
    @leagues = League.paginate(page: params[:page])
  end
  
  def show
    @league = League.find(params[:id])
    @team = Team.find_by(league_id: @league.id, user_id: current_user.id)
    store_league
  end
  
  def new
    @league = League.new
  end
  
  def create
    @league = League.new(league_params)
    
    numdivs = 0
    until numdivs >= league_params[:num_divisions].to_i do
      division = @league.divisions.new
      division.random_name
      division.save
      numdivs += 1
    end
    
    @division = @league.divisions.first
    @user = User.find(current_user)
    @team = @league.teams.new(:is_commissioner => true,
                              :user_id => @user.id,
                              :division_id => @division.id)
    @team.random_name
    @team.seed_lineups
    @team.save
    if @league.save
      flash[:success] = "League successfully created."
      redirect_to @league
    else
      render 'new'
    end
  end
  
  def edit
    @league = League.find(params[:id])
  end
  
  def update
    @league = League.find(params[:id])
    if @league.update_attributes(league_params)
      flash[:success] = "Settings updated"
      redirect_to @league
    else
      render 'edit'
    end
  end
  
  def destroy
    League.find(params[:id]).destroy
    flash[:success] = "League deleted"
    redirect_to leagues_url
  end
  
  private

    def league_params
      params.require(:league).permit(:name, :num_teams, :num_divisions)
    end
    
    # before filters
    
    # Confirms the correct league.
    def correct_league
      @league = League.find(params[:id])
      redirect_to(@league) unless current_league?(@league)
    end
    
    # confirm user is a part of the league
    def allowed_user
      @league = League.find(params[:id])
      redirect_back_or(leagues_url) unless current_user.leagues.include?(@league)
    end
end
