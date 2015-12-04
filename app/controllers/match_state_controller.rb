require 'match'

class MatchStateController < ApplicationController
  def state
    match = Match.find(params['match_id'].to_i)
    user = match.user_for_id(params['user_id'].to_i)
    state_for_user = match.state_for(user)
    if (params['format'] == 'json')
      render json: state_for_user.to_json
    else
      @perspective = state_for_user
      render :template => 'match_state/player'
    end
  end
end
