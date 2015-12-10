require_relative './common_steps.rb'
require_relative './helpers.rb'
require 'database_cleaner'

class Spinach::Features::StartGame < Spinach::FeatureSteps
  include Helpers

  step 'I am logged in' do
    @user = create(:real_user)
    visit '/users/sign_in'
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button "Log in"
    #expect(page).to have_content "Name: #{@user.name}"
  end

  step 'I choose my game options and play' do
    ask_to_play
  end

  step 'the match tells me to wait for opponents' do
    expect(page.text).to match(/waiting for (\d+) players/i)
  end

  step 'I am waiting for a game with 2 players' do
    ask_to_play(opponent_count: 1, player_name: @user.name)
    # page.within("#game_options") do
    #   fill_in 'user_name', with: @user.name
    #   fill_in 'user_id', with: ''
    #   select 1, from: 'number_of_opponents'
    #   click_button 'start_playing'
    # end
    # simulate_play_request(user: @user,
    #                       number_of_opponents: 1,
    #                       user_id: '',
    #                       reset_match_maker: true,
    #                       match_maker_timeout: 0.25)
  end

  step 'another player joins the game' do
    @another_user = create(:real_user)
    ask_to_play(opponent_count: 1, player_name: @another_user.name)
    puts "USERS: #{User.count}, #{User.all.map { |u| u.name + "|" +(u.type.nil? ? 'nil' : u.type) }}"
    # simulate_play_request(user: @another_user,
    #                       number_of_opponents: 1,
    #                       user_id: '')
  end

  step 'a player joins with the wrong number of opponents' do
    ask_to_play(opponent_count: 2, player_name: 'user2')
  end

  step 'no other player joins in time' do
    sleep 5 # TODO anything less doesn't work consistently
  end

  step 'the game starts' do
    # TODO how can I get rid of "first" stuff when there's no match to grab?
    automatically_created_match = Match.first
    first_user = automatically_created_match.users.first
    visit "/matches/#{automatically_created_match.id}/users/#{first_user.id}"
    expect(page).to have_content "Welcome, #{first_user.name}"
    expect(page).to have_content /click a card/i
  end

  step 'I am playing one opponent' do
    expect(find_all('.opponent').length).to eq 1
    expect(find('.opponent').text).to match @another_user.name
  end

  step 'I am playing one robot' do
    expect(find_all('.opponent').length).to eq 1
    expect(find('.opponent').text).to match /robot\d+/i
  end
end
