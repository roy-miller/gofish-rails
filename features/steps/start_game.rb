require_relative './common_steps.rb'
require_relative './helpers.rb'
require 'database_cleaner'

class Spinach::Features::StartGame < Spinach::FeatureSteps
  include Helpers

  step 'I am logged in' do
    @user = create(:real_user)
    in_browser("#{@user.name}_session") do
      visit '/users/sign_in'
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button "Log in"
    end
  end

  step 'two authenticated users' do
    @user = create(:real_user)
    @another_user = create(:real_user)
    [@user, @another_user].each do |user|
      in_browser("#{user.name}_session") do
        visit '/users/sign_in'
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button "Log in"
      end
    end
  end

  step 'the match tells me to wait for opponents' do
    in_browser("#{@user.name}_session") do
      expect(page.text).to match(/waiting for (\d+) players/i)
    end
  end

  step 'I am waiting for a game with 2 players' do
    in_browser("#{@user.name}_session") do
      ask_to_play(opponent_count: 1, player_name: @user.name)
    end
  end

  step 'another player joins the game' do
    in_browser("#{@another_user.name}_session") do
      page.within("#game_options") do
        select 1, from: 'number_of_opponents'
        click_button 'start_playing'
      end
    end
  end

  step 'another player joins with the wrong number of opponents' do
    @another_user = create(:real_user)
    in_browser("#{@another_user.name}_session") do
      ask_to_play(opponent_count: 2, player_name: @another_user.name)
    end
  end

  step 'no other player joins in time' do
    sleep 5 # TODO anything less doesn't work consistently
  end

  step 'the game starts' do
    # TODO how can I get rid of "first" stuff when there's no match to grab?
    automatically_created_match = Match.first
    first_user = automatically_created_match.users.first
    in_browser("#{@user.name}_session") do
      visit "/matches/#{automatically_created_match.id}/users/#{first_user.id}"
      expect(page).to have_content "Welcome, #{first_user.name}"
      expect(page).to have_content /click a card/i
    end
  end

  step 'I am playing one opponent' do
    in_browser("#{@user.name}_session") do
      expect(find_all('.opponent').length).to eq 1
      expect(find('.opponent').text).to match @another_user.name
    end
  end

  step 'I am playing one robot' do
    in_browser("#{@user.name}_session") do
      expect(find_all('.opponent').length).to eq 1
      expect(find('.opponent').text).to match /robot\d+/i
    end
  end

  step 'check this' do
    @user = create(:real_user)
    @another_user = create(:real_user)
    puts User.all.map(&:name)
    in_browser('user1_session') do
      visit '/users/sign_in'
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button "Log in"
    end
    in_browser('user2_session') do
      visit '/users/sign_in'
      fill_in 'Email', with: @another_user.email
      fill_in 'Password', with: @another_user.password
      click_button "Log in"
    end
    in_browser('user1_session') do
      puts "BEFORE USER1 PLAYS: #{Time.now}"
      page.within("#game_options") do
        select 1, from: 'number_of_opponents'
        click_button 'start_playing'
      end
      puts "user1 after waiting..."
      puts "  ->  " + page.text
    end
    in_browser('user2_session') do
      puts "BEFORE USER2 PLAYS: #{Time.now}"
      page.within("#game_options") do
        select 1, from: 'number_of_opponents'
        click_button 'start_playing'
      end
      puts "user2 after joining..."
      puts "  ->  " + page.text
    end
    puts "AFTER USER2 PLAYS: #{Time.now}"
    puts User.all.map(&:name)
    automatically_created_match = Match.first
    first_user = automatically_created_match.users.first
    in_browser('user1_session') do
      visit "/matches/#{automatically_created_match.id}/users/#{first_user.id}"
      puts "USER1 SEES"
      puts page.text
      expect(page).to have_content "Welcome, #{first_user.name}"
      expect(page).to have_content /click a card/i
    end
    in_browser('user1_session') do
      expect(find_all('.opponent').length).to eq 1
      expect(find('.opponent').text).to match @another_user.name
    end
  end

end
