# This will guess the User class
FactoryBot.define do
  factory :purchase do
    amount { Faker::Number.decimal(2, 3)  }
    user { nil }

    trait :with_user do
      user { create(:user) }
    end

    trait :income do
      refunded { false }
      completed { true }
    end
  end
end
