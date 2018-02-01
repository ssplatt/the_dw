class NFLApi
  include HTTParty
  #wrapper for nfl.com fantasy player stats
  base_uri 'http://api.fantasy.nfl.com/v1'
  
  def initialize()
  end
  
  # Get a list of fantasy stats used throughout fantasy.
  def get_stats_headers(options={format: "json"})
    Rails.cache.fetch(["/game/stats", { query: options }], :expires => 1.hour) do
      self.class.get("/game/stats", { query: options })
    end
  end

  def get_players_stats(options={format: "json"})
    #player stats
    #http://api.fantasy.nfl.com/v1/docs/service?serviceName=playersStats
    #stattype, season, week, position
    # stattype: seasonStats, weekStats, seasonProjectedStats, weekProjectedStats, twoWeekStats, fourWeekStats
    # season: year number
    # week: week number
    # position: QB, RB, WR, TE, K , DEF, DL, LB, DB. Only supports PPR for RB-ppr, WR-ppr, and TE-ppr.
    Rails.cache.fetch(["/players/stats", { query: options }], :expires => 1.hour) do
      self.class.get("/players/stats", { query: options })
    end
  end
  
  def get_players_details(id)
    #player details
    #http://api.fantasy.nfl.com/v1/docs/service?serviceName=playersDetails
    # playerId
    options = { :playerId => id.to_s, format: "json" }
    Rails.cache.fetch(["/players/details", { query: options }], :expires => 1.hour) do
      self.class.get("/players/details", { query: options })
    end
  end
  
  def get_players_weekstats(options={format: "json"})
    #live stats
    #http://api.fantasy.nfl.com/v1/docs/service?serviceName=playersWeekStats
    #season, week, position
    Rails.cache.fetch(["/players/weekstats", { query: options }], :expires => 1.hour) do
      self.class.get("/players/weekstats", { query: options })
    end
  end
end