class StartController < ApplicationController
  # before_action :authenticate_user!, except: :simulate_start
  skip_before_filter :verify_authenticity_token, :only => [:simulate_start]
  # MyMatchMaker ||= MatchMaker.new
  #
  # def wait
  #   reset_match_maker if (params['reset_match_maker'] == 'true')
  #   match_maker.start_timeout_seconds = params['match_maker_timeout'].to_f if (params['match_maker_timeout'])
  #   @number_of_players = params['number_of_opponents'].to_i + 1
  #   @user = current_user
  #   if match = match_maker.match(current_user, @number_of_players)
  #     match.users.each { |user| Pusher.trigger("wait_channel_#{user.id}", 'match_start_event', { message: "/matches/#{match.id}/users/#{user.id}" }) }
  #     respond_to do |format|
  #       format.json { render :json => { message: "refresh" } }
  #       format.html { redirect_to "/matches/#{match.id}/users/#{current_user.id}", status: :found }
  #     end
  #   else
  #     respond_to do |format|
  #       format.json { render :json => { message: "Waiting for #{@number_of_players} players" } }
  #       format.html { render 'start/wait' }
  #     end
  #   end
  # end

  def simulate_start
    user1 = RealUser.create(name: 'user1', email: "user1#{(Time.now.to_f * 100000).to_i}@gofish.com", password: 'password')
    user2 = RealUser.create(name: 'user2', email: "user2#{(Time.now.to_f * 100000).to_i}@gofish.com", password: 'password')
    match = Match.create(users: [user1, user2])
    match.start
    MatchClientNotifier.new.observe_match(match)
    match.save!
    respond_to do |format|
      format.json { render :json => match.state_for(user1).to_json }
    end
    #redirect_to "/matches/#{match.id}/users/#{user1.id}.json", status: :found
  end

  # protected
  #
  # def match_maker
  #   MyMatchMaker
  # end
  #
  # def match_maker_timeout=(value)
  #   match_maker.start_timeout_seconds = value
  # end
  #
  # def reset_match_maker
  #   match_maker.pending_users = nil
  # end
end
