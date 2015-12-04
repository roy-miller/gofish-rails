require 'match'

class CardRequestController < ApplicationController
  def make_request
    match_id = params['match_id']
    match = Match.find(match_id)
    requestor = match.user_for_id(params['requestor_id'].to_i)
    recipient = match.user_for_id(params['requested_id'].to_i)
    match.ask_for_cards(requestor: requestor, recipient: recipient, card_rank: params['rank'].upcase)
    match.save!
    render json: nil, status: :ok
  end
end
