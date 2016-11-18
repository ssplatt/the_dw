require "nflapi"

class LineupsController < ApplicationController
  before_action :correct_lineup,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  def index
    @lineups = Lineup.paginate(page: params[:page])
  end
  
  def show
    @lineup = Lineup.find(params[:id])
    @nfl = NFLApi.new
    @qb = @nfl.get_players_details(@lineup.qb_id)["players"][0]
    @rb1 = @nfl.get_players_details(@lineup.rb1_id)["players"][0]
    @rb2 = @nfl.get_players_details(@lineup.rb2_id)["players"][0]
    @wr1 = @nfl.get_players_details(@lineup.wr1_id)["players"][0]
    @wr2 = @nfl.get_players_details(@lineup.wr2_id)["players"][0]
  end
  
  def new
    @nfl = NFLApi.new
    @nfl_qbs = @nfl.get_players_stats({:position => "QB"})["players"]
    @nfl_qbs = @nfl_qbs.sort_by { |player| [player['weekProjectedPts'].to_f] }.reverse!
    @nfl_rbs = @nfl.get_players_stats({:position => "RB"})["players"]
    @nfl_rbs = @nfl_rbs.sort_by { |player| [player['weekProjectedPts'].to_f] }.reverse!
    @nfl_wrs = @nfl.get_players_stats({:position => "WR"})["players"]
    @nfl_tes = @nfl.get_players_stats({:position => "TE"})["players"]
    @nfl_wrstes = @nfl_wrs + @nfl_tes
    @nfl_wrstes = @nfl_wrstes.sort_by { |player| [player['weekProjectedPts'].to_f] }.reverse!
    @lineup = Lineup.new
    @lineup.week = @nfl.get_players_stats({:position => "QB"})["week"]
    #@lineup.season = @nfl.get_players_stats({:position => "QB"})["season"]
  end
  
  def create
    @lineup = Lineup.new(lineup_params)
    @lineup.team_id ||= current_team.id
    if @lineup.save
      flash[:info] = "New Lineup Created"
      redirect_to @lineup
    else
      render 'new'
    end
  end
  
  def edit
    @nfl = NFLApi.new
    @nfl_qbs = @nfl.get_players_stats({:position => "QB"})["players"]
    @nfl_qbs = @nfl_qbs.sort_by { |player| [player['weekProjectedPts'].to_f] }.reverse!
    @nfl_rbs = @nfl.get_players_stats({:position => "RB"})["players"]
    @nfl_rbs = @nfl_rbs.sort_by { |player| [player['weekProjectedPts'].to_f] }.reverse!
    @nfl_wrs = @nfl.get_players_stats({:position => "WR"})["players"]
    @nfl_tes = @nfl.get_players_stats({:position => "TE"})["players"]
    @nfl_wrstes = @nfl_wrs + @nfl_tes
    @nfl_wrstes = @nfl_wrstes.sort_by { |player| [player['weekProjectedPts'].to_f] }.reverse!
    @lineup = Lineup.find(params[:id])
  end
  
  def update
    @lineup = Lineup.find(params[:id])
    if @lineup.update_attributes(lineup_params)
      flash[:success] = "Lineup updated"
      redirect_to @lineup
    else
      render 'edit'
    end
  end
  
  def destroy
    Lineup.find(params[:id]).destroy
    flash[:success] = "Lineup deleted"
    redirect_to lineups_url
  end
  
  private

    def lineup_params
      params.require(:lineup).permit(:qb_id, :rb1_id, :rb2_id, :wr1_id, :wr2_id, :week, :season)
    end
    
    # Confirms the correct team.
    def correct_lineup
      @lineup = Lineup.find(params[:id])
      redirect_to(@lineup) unless current_lineup?(@lineup) || current_user.admin?
    end
  
end
