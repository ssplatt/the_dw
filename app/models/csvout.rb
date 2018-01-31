require "nflapi"
@nfl = NFLApi.new

@week = params[:week] || 1
@season = params[:season] || 2017

@nfl_qbs = @nfl.get_players_stats(
    {
        :position => "QB",
        :week => @week,
        :season => @season,
        :statType => "weekProjectedStats"
    })["players"]
@nfl_qbs = @nfl_qbs.sort_by { |player| [player['weekProjectedPts'].to_f] }.reverse!

@nfl_rbs = @nfl.get_players_stats(
    {
        :position => "RB", 
        :week => @week, 
        :season => @season, 
        :statType => "weekProjectedStats"
    }
    )["players"]
@nfl_rbs = @nfl_rbs.sort_by { |player| [player['weekProjectedPts'].to_f] }.reverse!

@nfl_wrs = @nfl.get_players_stats(
    {
        :position => "WR", 
        :week => @week, 
        :season => @season, 
        :statType => "weekProjectedStats"
        
    }
    )["players"]
@nfl_tes = @nfl.get_players_stats(
    {
        :position => "TE", 
        :week => @week, 
        :season => @season, 
        :statType => "weekProjectedStats"
    }
    )["players"]

@nfl_wrstes = @nfl_wrs + @nfl_tes
@nfl_wrstes = @nfl_wrstes.sort_by { |player| [player['weekProjectedPts'].to_f] }.reverse!

@players = @nfl_qbs + @nfl_rbs + @nfl_wrstes
@statheaders = @nfl.get_stats_headers()["stats"]

print "name,position,team,"
@statheaders.each do |stat|
    print "#{stat["name"]},"
end
print "\n"

@players.each do |player|
    print "#{player["name"]},#{player["position"]},#{player["teamAbbr"]},"
    (1..93).each do |i|
        if player["stats"][i.to_s]
           print "#{player["stats"][i.to_s]},"
       else
           print ","
       end
    end
    print "\n"
end
