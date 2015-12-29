class StartController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:simulate_start]

  def simulate_start
    user1 = RealUser.create(name: 'user1', email: "user1#{(Time.now.to_f * 100000).to_i}@gofish.com", password: 'password')
    user2 = RealUser.create(name: 'user2', email: "user2#{(Time.now.to_f * 100000).to_i}@gofish.com", password: 'password')
    match = Match.create(users: [user1, user2])
    match.start
    MatchClientNotifier.new.observe_match(match)
    match.save!
    state = match.state_for(user1)
    respond_to do |format|
      format.json { render :json => state.to_json }
    end
  end
end
