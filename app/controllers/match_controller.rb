class MatchController < ApplicationController
  def make_request
    match_id = params['match_id']
    match = Match.find(match_id)
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
    if (params['format'] == 'json')
      render json: state_for_user.to_json
    else
      @perspective = state_for_user
      render :template => 'match/show'
    end
  end
end
