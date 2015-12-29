FactoryGirl.define do
  factory :match do
    status MatchStatus::PENDING
    users { [] }
    #association :game, factory: :game, strategy: :build
    initialize_with { new({users: users}) }

    trait :users_have_no_cards do
      after(:build) do |match|
        match.users.each { |user| match.player_for(user).hand = [] }
      end
    end

    trait :users_have_cards_with_same_rank do
      after(:create) do |match|
        match.users.each { |user| match.player_for(user).hand = [build(:card, rank: 'A')] }
      end
    end
  end
end
