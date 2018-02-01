class Csvout
  include ActiveModel::Model
  
  def players_week_stats(nfl, week, season)
    nfl_qbs = nfl.get_players_stats(
      {
        :position => "QB",
        :week => week,
        :season => season,
        :statType => "weekStats"
      })["players"]
    nfl_qbs = nfl_qbs.sort_by { |player| [player['seasonPts'].to_f] }.reverse!
    
    nfl_rbs = nfl.get_players_stats(
      {
        :position => "RB", 
        :week => week, 
        :season => season, 
        :statType => "weekStats"
      }
      )["players"]
    nfl_rbs = nfl_rbs.sort_by { |player| [player['seasonPts'].to_f] }.reverse!
    
    nfl_wrs = nfl.get_players_stats(
      {
        :position => "WR",
        :week => week,
        :season => season,
        :statType => "weekStats"
      }
      )["players"]
    nfl_tes = nfl.get_players_stats(
      {
        :position => "TE",
        :week => week,
        :season => season,
        :statType => "weekStats"
      }
      )["players"]
    
    nfl_wrstes = nfl_wrs + nfl_tes
    nfl_wrstes = nfl_wrstes.sort_by { |player| [player['seasonPts'].to_f] }.reverse!
    
    players = nfl_qbs + nfl_rbs + nfl_wrstes
    statheaders = nfl.get_stats_headers()["stats"]
    
    output = "name,position,team,"
    statheaders.each do |stat|
      output << "#{stat["name"]},"
    end
    output << "\n"
    
    players.each do |player|
      output << "#{player["name"]},#{player["position"]},#{player["teamAbbr"]},"
      (1..93).each do |i|
        if player["stats"][i.to_s]
          output << "#{player["stats"][i.to_s]},"
        else
          output << ","
        end
      end
      output << "\n"
    end
    
    return output
  end
end
