# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user1 = User.create(name: 'user1')
user2 = User.create(name: 'user2')

def self.create_completed_match(winner:, losers:)
  users = [winner, losers].flatten!
  match = Match.create(users: users)
  match.status = MatchStatus::FINISHED
  match.game.deck.cards = []
  book_of_nines = Book.new
  %w{S D C H}.each do |suit|
    book_of_nines.cards << Card.new(rank: '9', suit: suit)
  end
  match.player_for(winner).books << book_of_nines
  match.winner = winner
  match.save!
end

(1..2).each do |index|
  create_completed_match(winner: user1, losers: [user2])
end

(1..1).each do |index|
  create_completed_match(winner: user2, losers: [user1])
end
