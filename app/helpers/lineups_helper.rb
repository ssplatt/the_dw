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
  
  def selected_players
    @selected_players = []
    lus = current_team.lineups.where.not(id: @lineup.id)
    lus.each do |p|
      if p.qb_id
        @selected_players.push(p.qb_id)
      end
      if p.rb1_id
        @selected_players.push(p.rb1_id)
      end
      if p.rb2_id
        @selected_players.push(p.rb2_id)
      end
      if p.wr1_id
        @selected_players.push(p.wr1_id)
      end
      if p.wr2_id
        @selected_players.push(p.wr2_id)
      end
    end
    return @selected_players
  end
end
