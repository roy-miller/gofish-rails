require 'rails_helper'
require 'benchmark'

RSpec.describe ApiController, type: :controller do
  include AuthenticationHelper

  let(:user) { create(:real_user) }

  describe '#authenticate' do
    context 'with valid login' do
      before do
        http_login user.email, user.password
        #request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("foo:password")
        post :authenticate
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq user
      end

      it 'returns user email and authentication token' do
        expect(response.body).to include user.email
        expect(response.body).to include user.authentication_token
      end
    end

    context 'with invalid login' do
      before do
        http_login "fake", "fake"
        post :authenticate
      end

      it 'does not assign @user' do
        expect(assigns(:user)).to eq nil
      end

      it 'returns an invalid login message' do
        expect(response.body).to match /invalid/i
      end
    end
  end

  describe '#authenticate_user_from_token!' do
    let(:correct_token) { user.authentication_token }
    let(:incorrect_token) { correct_token.chop }

    def mock_route
      Rails.application.routes.draw do
        get '/authenticate_user_from_token!', to: "api#authenticate_user_from_token!"
      end
    end

    def reset_routes
     Rails.application.reload_routes!
    end

    it 'signs in a user if the token matches a user' do
      http_give_token(correct_token)
      current_user = controller.authenticate_user_from_token!
      expect(current_user).not_to be nil
    end

    it 'returns an invalid token message and 401:unauthorized if the token does not match a user' do
      mock_route
      http_give_token(incorrect_token)
      get :authenticate_user_from_token!
      expect(response.body).to match /invalid/i
      reset_routes
    end

    # it 'takes roughly the same amount of time to complete when given no token as when given an incorrect token (prevents timing attacks)' do
    #   http_give_token(incorrect_token)
    #   incorrect_token_time = Benchmark.measure { get :authenticate_user_from_token! }.real
    #   http_give_token("")
    #   no_token_time = Benchmark.measure { get :authenticate_user_from_token! }.real
    #   expect(incorrect_token_time - no_token_time).to be < 0.001
    # end
  end

  def authenticate_user_for_action
    http_login user.email, user.password
    post :authenticate
    http_give_token(user.authentication_token)
  end

  describe '#create' do
    let!(:waiting_user) { create(:real_user, name: 'WaitingUser') }

    before do
      controller.send(:reset_match_maker)
      controller.send(:match_maker_timeout=, 0.25)
      authenticate_user_for_action
    end

    it 'returns ok if there are not enough real players' do
      post :create, {number_of_opponents: 1} #, {'HTTP_AUTHORIZATION' => 'uniquetoken'}
      expect(response).to have_http_status(200)
    end

    it 'starts a match and returns ok if there are enough real players' do
      controller.send(:match_maker).pending_users[2] = [waiting_user]
      allow(Pusher).to receive(:trigger).and_return(nil)
      post :create, {number_of_opponents: 1}
      expect(response).to have_http_status(200)
      expect(Pusher).to have_received(:trigger).once.with("wait_channel_#{waiting_user.id}", 'match_start_event', {:match_id => "1"})
      expect(Pusher).to have_received(:trigger).once.with("wait_channel_#{user.id}", 'match_start_event', {:match_id => "1"})
    end
  end

  describe "PATCH #update" do
    let(:another_user) { create(:real_user) }
    let(:match) { create(:match, :users_have_cards_with_same_rank, users: [user, another_user]) }

    before do
      authenticate_user_for_action
    end

    it 'updates match and returns ok response' do
      allow(match).to receive(:save!).and_return(nil)
      patch :update, id: match.id, requestor_id: user.id, requested_id: another_user.id, rank: 'A'
      expect(response).to have_http_status(200)
      parsed_body = JSON.parse(response.body)
    end
  end

  describe "GET #show" do
    before do
      http_login user.email, user.password
      post :authenticate
      http_give_token(user.authentication_token)
    end

    it 'returns match state for the user' do
      match = double("match")
      allow(Match).to receive(:find) { match }
      allow(match).to receive(:state_for).with(user).and_return({message: 'expected state'})
      allow(match).to receive(:user_for_id).with(user.id).and_return(user)
      get :show, id: 1
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['message']).to match(/expected/i)
    end
  end
end
