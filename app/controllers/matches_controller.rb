class MatchesController < ApplicationController
  before_action :authenticate_user!, except: :simulate_start
  MyMatchMaker ||= MatchMaker.new

  def edit
    match = Match.find(params['match_id'])
    requestor = match.user_for_id(params['requestor_id'].to_i)
    recipient = match.user_for_id(params['requested_id'].to_i)
    match.ask_for_cards(requestor: requestor, recipient: recipient, card_rank: params['rank'].upcase)
    match.save!
    render json: nil, status: :ok
  end

  def show
    match = Match.find(params['match_id'].to_i)
    user = match.user_for_id(params['user_id'].to_i)
    state_for_user = match.state_for(user)
    respond_to do |format|
      format.json { render :json => state_for_user.to_json }
      format.html {
        @perspective = state_for_user
        render :template => 'match/show'
      }
    end
  end

  def new
    reset_match_maker if (params['reset_match_maker'] == 'true')
    match_maker.start_timeout_seconds = params['match_maker_timeout'].to_f if (params['match_maker_timeout'])
    @number_of_players = params['number_of_opponents'].to_i + 1
    @user = current_user
    if match = match_maker.match(current_user, @number_of_players)
      match.users.each { |user| Pusher.trigger("wait_channel_#{user.id}", 'match_start_event', { message: "/matches/#{match.id}/users/#{user.id}" }) }
      respond_to do |format|
        format.json { render :json => { message: "refresh" } }
        format.html { redirect_to "/matches/#{match.id}/users/#{current_user.id}", status: :found }
      end
    else
      respond_to do |format|
        format.json { render :json => { message: "Waiting for #{@number_of_players} players" } }
        format.html { render 'start/wait' }
      end
    end
  end

  protected

  def match_maker
    MyMatchMaker
  end

  def match_maker_timeout=(value)
    match_maker.start_timeout_seconds = value
  end

  def reset_match_maker
    match_maker.pending_users = nil
  end
end
