require_relative './common_steps.rb'
require_relative './helpers.rb'

class Spinach::Features::EndGame < Spinach::FeatureSteps
  include Helpers
  include CommonSteps

  step 'a deck with one card left' do
    @match.game.deck.cards = [build(:card, rank: '4', suit: 'S')]
    @match.save!
  end

  step 'I have a book' do
    give_nines_book(@me)
    @match.save!
  end

  step 'the match tells me the game is over' do
    visit_player_page
    expect(page.has_content?(/game over/i)).to be true
  end

  step 'the match stores me as the winner' do
    expect(@match.winner.id).to be @me.id
  end
end
