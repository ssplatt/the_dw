require "nflapi"

class CsvoutController < ApplicationController

  def index
    @week = params[:week]
    @season = params[:season]
    @csv = Csvout.new
    render plain: @csv.players_week_stats()
  end
  
  private
    
end
