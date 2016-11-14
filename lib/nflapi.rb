class NFLApi
  include HTTParty
  #wrapper for nfl.com player stats
  base_uri 'http://api.fantasy.nfl.com/v1'
  
  def initialize()
  end

  def get_players_stats(options={})
    #player stats
    #http://api.fantasy.nfl.com/v1/docs/service?serviceName=playersStats
    #stattype, season, week, position
    Rails.cache.fetch(["/players/stats", { query: options }], :expires => 1.hour) do
      self.class.get("/players/stats", { query: options })
    end
  end
  
  def get_players_details(playerid)
    #player details
    #http://api.fantasy.nfl.com/v1/docs/service?serviceName=playersDetails
    options = {:playerId => playerid}
    Rails.cache.fetch(["/players/details", { query: options }], :expires => 1.hour) do
      self.class.get("/players/details", { query: options })
    end
  end
  
  def get_players_weekstats(options={})
    #live stats
    #http://api.fantasy.nfl.com/v1/docs/service?serviceName=playersWeekStats
    #season, week, position
    Rails.cache.fetch(["/players/weekstats", { query: options }], :expires => 1.hour) do
      self.class.get("/players/weekstats", { query: options })
    end
  end
end