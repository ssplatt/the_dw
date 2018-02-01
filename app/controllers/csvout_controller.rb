require "nflapi"

class CsvoutController < ApplicationController

  def index
    @week = params[:week]
    @season = params[:season]
    @nfl = NFLApi.new
    @csv = Csvout.new
    render plain: @csv.players_week_stats(@nfl, @week, @season)
  end
  
  private
    
end
