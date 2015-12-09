require_relative './common_steps.rb'
require_relative './helpers.rb'

class Spinach::Features::UserAuthentication < Spinach::FeatureSteps
  include Helpers

  step 'an existing user' do
    @user_name = 'existinguser'
    @user_email = 'existinguser@example.com'
    @user_password = 'password'
    create(:registered_user, name: @user_name,
                             email: @user_email,
                             password: @user_password)
  end

  step 'I try to login' do
    visit '/'
    click_link 'login'
  end

  step 'I register as a new user' do
    @user_name = 'newuser'
    @user_email = 'newuser@someplace.com'
    @user_password = 'password'
    click_link 'Sign up'
    fill_in 'Name', with: @user_name
    fill_in 'Email', with: @user_email
    fill_in 'Password', with: @user_password
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'
  end

  step 'I am on the welcome page' do
    visit_welcome_page
  end

  step 'I login' do
    click_link 'login'
    fill_in 'Email', with: @user_email
    fill_in 'Password', with: @user_password
    click_button 'Log in'
  end

  step 'I see an invalid login message' do
    expect(page).to have_content /invalid email or password/i
  end

  step 'I see my user information' do
    expect(page).to have_content "Name: #{@user_name}"
  end

  step 'an authenticated user' do
    an_existing_user
    i_am_on_the_welcome_page
    i_login
  end

  step 'I logout' do
    click_link 'logout'
  end

  step 'I am logged out' do
    expect(page).to have_content /signed out successfully/i
  end
end
