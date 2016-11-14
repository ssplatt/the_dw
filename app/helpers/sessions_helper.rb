require "nflapi"

module SessionsHelper
  
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end
  
  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end
  
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    session.delete(:league_id)
    session.delete(:team_id)
    session.delete(:lineup_id)
    @current_user = nil
    @current_league = nil
    @current_team = nil
    @current_lineup = nil
  end
  
  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
  
  # Returns true if the given team is the current team.
  def current_team?(team)
    team == current_team
  end
  
  # Returns the current team.
  def current_team
    if (team_id = session[:team_id])
      @current_team ||= Team.find_by(id: team_id)
    end
  end
  
  # Returns true if the given league is the current league.
  def current_league?(league)
    league == current_league
  end
  
  # Returns the current league.
  def current_league
    if (league_id = session[:league_id])
      @current_league ||= League.find_by(id: league_id)
    end
  end
  
  # Returns true if the given lineup is the current lineup.
  def current_lineup?(lineup)
    lineup == current_lineup
  end
  
  # Returns the current lineup.
  def current_lineup
    if (lineup_id = session[:lineup_id])
      @current_lineup ||= Lineup.find_by(id: lineup_id)
    end
  end
  
  # stores the current league
  def store_league
    if (current_user.leagues.find(@league.id))
      session[:league_id] = @league.id
    end
  end
  
  # store the current team
  def store_team
    if (current_user.teams.find(@team.id))
      session[:team_id] = @team.id
      session[:league_id] = @team.league_id
    end
  end
  
  # store current line up
  def store_lineup
    if (current_user.teams.lineups.find(@lineup.id))
      session[:lineup_id] = @lineup.id
      session[:team_id] = @lineup.team_id
      session[:league_id] = @lineup.league_id
    end
  end
  
  def current_week
    @nfl = NFLApi.new
    @current_week = @nfl.get_players_stats({:position => "QB"})["week"]
  end
  
  def current_season
    @nfl = NFLApi.new
    @current_season = @nfl.get_players_stats({:position => "QB"})["season"]
  end
end
