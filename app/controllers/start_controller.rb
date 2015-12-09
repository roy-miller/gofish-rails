class StartController < ApplicationController
  before_action :authenticate_user!
  MyMatchMaker ||= MatchMaker.new

  def wait
    Rails.logger.debug "\n\n\n********** GOT HERE **********\n\n\n"
    reset_match_maker if (params['reset_match_maker'] == 'true')
    match_maker.start_timeout_seconds = params['match_maker_timeout'].to_f if (params['match_maker_timeout'])
    @number_of_players = params['number_of_opponents'].to_i + 1
    Rails.logger.debug "\n\n\n***** current_user = #{current_user}\n\n\n"
    if match = match_maker.match(current_user, @number_of_players)
      Rails.logger.debug "\n\n\n***** GOT MATCH\n\n\n"
      match.users.each { |user| Pusher.trigger("wait_channel_#{user.id}", 'match_start_event', { message: "/matches/#{match.id}/users/#{user.id}" }) }
      redirect_to "/matches/#{match.id}/users/#{user.id}", status: :found
    else
      Rails.logger.debug "\n\n\n***** NO MATCH YET\n\n\n"
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
