module LineupsHelper
  
  def disabled_weeks
    min = 1
    max = current_week.to_i - 1
    if (min < max)
      @disabled_weeks = (min..max)
    else
      @disabled_weeks = []
    end
    return @disabled_weeks
  end
  
  def locked?(player_week_stats)
    if player_week_stats["stats"]
      return player_week_stats["stats"]["1"] == "1" ? true : false
    else
      return false
    end
  end
end
