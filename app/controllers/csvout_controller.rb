require "nflapi"

class CSVOutController < ApplicationController

  def index
    @week = params[:week] || 1
    @season = params[:season] || 2017
  end
  
  private
    
end
