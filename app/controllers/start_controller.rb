class StartController < ApplicationController
  before_action :authenticate_user!
  MyMatchMaker ||= MatchMaker.new

  def wait
    reset_match_maker if (params['reset_match_maker'] == 'true')
    match_maker.start_timeout_seconds = params['match_maker_timeout'].to_f if (params['match_maker_timeout'])
    @number_of_players = params['number_of_opponents'].to_i + 1
    if match = match_maker.match(current_user, @number_of_players)
      match.users.each { |user| Pusher.trigger("wait_channel_#{user.id}", 'match_start_event', { message: "/matches/#{match.id}/users/#{user.id}" }) }
      redirect_to "/matches/#{match.id}/users/#{current_user.id}", status: :found
    else
      @user = current_user
      render :template => 'start/wait'
    end
  end

  protected

  def match_maker
    MyMatchMaker
  end

  def match_maker_timout=(value)
    match_maker.start_timeout_seconds = value
  end

  def reset_match_maker
    match_maker.pending_users = nil
  end
end
