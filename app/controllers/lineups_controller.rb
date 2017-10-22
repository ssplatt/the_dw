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
    @weekstats = @nfl.get_players_stats({:statType => "weekStats",:season => @lineup.team.league.season, :week => @lineup.week})["players"]
    
    @qb = @lineup.qb_id ? @nfl.get_players_details(@lineup.qb_id)["players"][0] : {}
    @rb1 = @lineup.rb1_id ? @nfl.get_players_details(@lineup.rb1_id)["players"][0] : {}
    @rb2 = @lineup.rb2_id ? @nfl.get_players_details(@lineup.rb2_id)["players"][0] : {}
    @wr1 = @lineup.wr1_id ? @nfl.get_players_details(@lineup.wr1_id)["players"][0] : {}
    @wr2 = @lineup.wr2_id ? @nfl.get_players_details(@lineup.wr2_id)["players"][0] : {}
    
    @qb_stats = @weekstats.select{ |h| h["id"] == @lineup.qb_id.to_s }[0] || {}
    @lineup.qb_score = @qb_stats && @qb_stats.length > 0 ? calc_score(@qb_stats) : 0
    
    @rb1_stats = @weekstats.select{ |h| h["id"] == @lineup.rb1_id.to_s }[0] || {}
    @lineup.rb1_score = @rb1_stats && @rb1_stats.length > 0 ? calc_score(@rb1_stats) : 0
    
    @rb2_stats = @weekstats.select{ |h| h["id"] == @lineup.rb2_id.to_s }[0] || {}
    @lineup.rb2_score = @rb2_stats && @rb2_stats.length > 0 ? calc_score(@rb2_stats) : 0
    
    @wr1_stats = @weekstats.select{ |h| h["id"] == @lineup.wr1_id.to_s }[0] || {}
    @lineup.wr1_score = @wr1_stat && @wr1_stats.length > 0 ? calc_score(@wr1_stats) : 0
    
    @wr2_stats = @weekstats.select{ |h| h["id"] == @lineup.wr2_id.to_s }[0] || {}
    @lineup.wr2_score = @wr2_stats && @wr2_stats.length > 0 ? calc_score(@wr2_stats) : 0
    
    @lineup.total_score = (@lineup.qb_score + @lineup.rb1_score + @lineup.rb2_score +
                          @lineup.wr1_score + @lineup.wr2_score).round(2)
    @lineup.save
    store_lineup
  end
  
  def new
    @lineup = Lineup.new
    @lineup.week = @nfl.get_players_stats({:position => "QB", :season => @lineup.team.league.season})["week"]
    
    @nfl = NFLApi.new
    @nfl_qbs = @nfl.get_players_stats({:position => "QB", :season => @lineup.team.league.season})["players"]
    @nfl_qbs = @nfl_qbs.sort_by { |player| [player['weekProjectedPts'].to_f] }.reverse!
    @nfl_rbs = @nfl.get_players_stats({:position => "RB", :season => @lineup.team.league.season})["players"]
    @nfl_rbs = @nfl_rbs.sort_by { |player| [player['weekProjectedPts'].to_f] }.reverse!
    @nfl_wrs = @nfl.get_players_stats({:position => "WR", :season => @lineup.team.league.season})["players"]
    @nfl_tes = @nfl.get_players_stats({:position => "TE", :season => @lineup.team.league.season})["players"]
    @nfl_wrstes = @nfl_wrs + @nfl_tes
    @nfl_wrstes = @nfl_wrstes.sort_by { |player| [player['weekProjectedPts'].to_f] }.reverse!
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
    @lineup = Lineup.find(params[:id])
    @league = @lineup.team.league
    @nfl = NFLApi.new
    @nfl_qbs = @nfl.get_players_stats({:position => "QB", :week => @lineup.week, :season => @lineup.team.league.season, :statType => "weekProjectedStats"})["players"]
    @nfl_qbs = @nfl_qbs.sort_by { |player| [player['weekProjectedPts'].to_f] }.reverse!
    @nfl_rbs = @nfl.get_players_stats({:position => "RB", :week => @lineup.week, :season => @lineup.team.league.season, :statType => "weekProjectedStats"})["players"]
    @nfl_rbs = @nfl_rbs.sort_by { |player| [player['weekProjectedPts'].to_f] }.reverse!
    @nfl_wrs = @nfl.get_players_stats({:position => "WR", :week => @lineup.week, :season => @lineup.team.league.season, :statType => "weekProjectedStats"})["players"]
    @nfl_tes = @nfl.get_players_stats({:position => "TE", :week => @lineup.week, :season => @lineup.team.league.season, :statType => "weekProjectedStats"})["players"]
    @nfl_wrstes = @nfl_wrs + @nfl_tes
    @nfl_wrstes = @nfl_wrstes.sort_by { |player| [player['weekProjectedPts'].to_f] }.reverse!
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
      params.require(:lineup).permit(:qb_id, :rb1_id, :rb2_id, :wr1_id, :wr2_id, :week, :division_id)
    end
    
    # Confirms the correct team.
    def correct_lineup
      @lineup = Lineup.find(params[:id])
      redirect_to(@lineup) unless current_team?(@lineup.team) || current_user.admin? || current_team.is_commissioner?
    end
    
    def calc_score(player_week_stats)
      score = 0
      
      player_week_stats["stats"].each do |k,v|
        case k
        when "5"
          score += v.to_i * @lineup.team.league.pa_yd
        when "6"
          score += v.to_i * @lineup.team.league.pa_td
        when "7"
          score += v.to_i * @lineup.team.league.pa_int
        when "14"
          score += v.to_i * @lineup.team.league.ru_yd
        when "15"
          score += v.to_i * @lineup.team.league.ru_td
        when "20"
          score += v.to_i * @lineup.team.league.rec
        when "21"
          score += v.to_i * @lineup.team.league.re_yd
        when "22"
          score += v.to_i * @lineup.team.league.re_td
        when "30"
          score += v.to_i * @lineup.team.league.fuml
        when "31"
          score += v.to_i * @lineup.team.league.fum
        when "32"
          score += v.to_i * @lineup.team.league.tpc
        end
      end
      
      return score.round(2)
    end
  
end
