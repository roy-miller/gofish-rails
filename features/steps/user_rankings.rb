class Spinach::Features::UserRankings < Spinach::FeatureSteps
  include Helpers

  step 'a set of completed matches' do
    @user1 = create(:user, name: 'user1')
    user2 = create(:user, name: 'user2')
    create_completed_match(winner: @user1, losers: [user2])
    create_completed_match(winner: @user1, losers: [user2])
    create_completed_match(winner: user2, losers: [@user1])
  end

  step 'I view my performance' do
    visit user_path(@user1)
  end

  step 'I see my wins and losses' do
    expect(page).to have_content /Name: user1/i
    expect(page).to have_content /Wins: 2/i
    expect(page).to have_content /Losses: 1/i
  end

  step 'I see my ranking' do
    page.save_screenshot('/Users/roymiller/gofish.png')
    expect(first('.ranked-user')).to have_content @user1.name
  end
end
