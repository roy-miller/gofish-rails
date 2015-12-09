FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }

    factory :registered_user, class: RegisteredUser, parent: :user do
      email { "#{name}@example.com" }
      password { "password" }
    end

    factory :robot_user, class: RobotUser, parent: :user do
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
