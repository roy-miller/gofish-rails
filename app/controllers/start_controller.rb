require 'user'
require 'match_maker'

class StartController < ApplicationController
  @@match_maker = MatchMaker.new

  def index
    @@match_maker = MatchMaker.new if (params['reset_match_maker'] == 'true')
    @@match_maker.start_timeout_seconds = params['match_maker_timeout'].to_f if (params['match_maker_timeout'])
    @number_of_players = params['number_of_opponents'].to_i + 1
    user = User.find_or_create_by(name: params['user_name'])
    match = @@match_maker.match(user, @number_of_players)
    if match
      #match.save!
      match.users.each { |user| Pusher.trigger("wait_channel_#{user.id}", 'match_start_event', { message: "/matches/#{match.id}/users/#{user.id}" }) }
      redirect "/matches/#{match.id}/users/#{user.id}"
    else
      @user_id = user.id
      @user_name = user.name
      render :template => 'start/wait'
    end
  end
end
