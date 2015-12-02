FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }

    factory :robot_user, class: RobotUser, parent: :user do
      #sequence(:name) { |n| "robot#{n}" }
      #name 'robot'
      think_time 0

      trait :thinker do
        think_time 2.5
      end

      trait :slow_thinker do
        think_time 10
      end

      after(:create) do |robot, evaluator|
        robot.update_column(:name, "robot#{robot.id}")
        robot.reload
        robot.save
      end
    end
  end
end
