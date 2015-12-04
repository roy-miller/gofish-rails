FactoryGirl.define do
  factory :book do
    cards { [] }

    trait :nines do
      cards { %w{S D C H}.map do |suit|
        build(:card, rank: '9', suit: suit)
      end }
    end
  end
end
