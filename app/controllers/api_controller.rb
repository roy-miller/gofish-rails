class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user_from_token!, except: [:authenticate, :test]
  before_action :set_default_response_format

  MyMatchMaker ||= MatchMaker.new

  def authenticate
    authenticate_with_http_basic do |email, password|
      @user = User.find_by_email(email.downcase)
      render json: { error: 'Invalid email or password' }, status: :unauthorized unless @user && @user.valid_password?(password)
    end
  end

  def authenticate_user_from_token!
    authenticate_with_http_token do |token, options|
      user = User.find_by_authentication_token(token)
      sign_in user, store: false and return current_user if user
    end
    render json: { error: 'Invalid token' }, status: :unauthorized
  end

  def new
  end

  def create
    reset_match_maker if (params['reset_match_maker'] == 'true')
    match_maker.start_timeout_seconds = params['match_maker_timeout'].to_f if (params['match_maker_timeout'])
    number_of_players = params['number_of_opponents'].to_i + 1
    match = match_maker.match(current_user, number_of_players)
    push_to_waiters(match) if match
    render json: {}, status: :ok
  end

  def update
    match = Match.find(params[:id].to_i)
    match.ask_for_cards(requestor: match.user_for_id(params[:requestor_id].to_i),
                        recipient: match.user_for_id(params[:requested_id].to_i),
                        card_rank: params[:rank].upcase)
    match.save!
    render json: {}, status: :ok
  end

  def show
    match = Match.find(params[:id].to_i)
    user = match.user_for_id(current_user.id)
    state_for_user = match.state_for(user)
    render :json => state_for_user.to_json, status: :ok
  end

  protected

  def match_maker
    MyMatchMaker
  end

  def push_to_waiters(match)
    match.users.each { |user| Pusher.trigger("wait_channel_#{user.id}", 'match_start_event', { match_id: "#{match.id}" }) }
  end

  def match_maker_timeout=(value)
    match_maker.start_timeout_seconds = value
  end

  def reset_match_maker
    match_maker.pending_users = nil
  end

  def set_default_response_format
    request.format = :json
  end
end

# def valid_password(user, password)
#   BCrypt::Password.new(user.encrypted_password) == password
# end
