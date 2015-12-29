FactoryGirl.define do
  factory :user do
    sequence(:name) { |number| "user#{number}" }

    factory :real_user, class: RealUser, parent: :user do
      sequence(:email) { |n| "#{name}#{n}@example.com" }
      password { "password" }
    end

    factory :robot_user, class: RobotUser, parent: :user do
      email { "robot#{'astring'.object_id}@dummydomain.com" }
      think_time 0

      trait :thinker do
        think_time 2.5
      end

      trait :slow_thinker do
        think_time 10
      end

      after(:create) do |robot, evaluator|
        robot.name = "robot#{robot.id}"
        robot.save
      end
    end
  end
end
