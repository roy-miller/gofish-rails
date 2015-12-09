require_relative './common_steps.rb'
require_relative './helpers.rb'
require 'database_cleaner'

class Spinach::Features::StartGame < Spinach::FeatureSteps
  include Helpers

  step 'I am logged in' do
    @user = create(:registered_user)
    visit '/registered_users/sign_in'
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button "Log in"
    expect(page).to have_content "Name: #{@user.name}"
  end

  step 'I choose my game options and play' do
    ask_to_play
  end

  step 'the match tells me to wait for opponents' do
    expect(page.text).to match(/waiting for (\d+) players/i)
  end

  step 'I am waiting for a game with 2 players' do
    binding.pry
    simulate_play_request(user: @user,
                          number_of_opponents: 1,
                          user_id: '',
                          reset_match_maker: true,
                          match_maker_timeout: 0.25)
  end

  step 'another player joins the game' do
    simulate_play_request(user: create(:registered_user, name: 'user2'),
                          number_of_opponents: 1,
                          user_id: '')
  end

  step 'a player joins with the wrong number of opponents' do
    ask_to_play(opponent_count: 2, player_name: 'user2', user_id: '')
  end

  step 'no other player joins in time' do
    sleep 5 # TODO anything less doesn't work consistently
  end

  step 'the game starts' do
    binding.pry
    # TODO how can I get rid of "first" stuff when there's no match to grab?
    visit "/matches/#{Match.first.id}/users/#{Match.first.users.first.id}"
    expect(page.text).to have_text /welcome, user1/i
    expect(page.text).to have_text /click a card/i
  end

  step 'I am playing one opponent' do
    expect(find_all('.opponent').length).to eq 1
    expect(find('.opponent').text).to match /user2/i
  end

  step 'I am playing one robot' do
    expect(find_all('.opponent').length).to eq 1
    expect(find('.opponent').text).to match /robot\d+/i
  end
end
