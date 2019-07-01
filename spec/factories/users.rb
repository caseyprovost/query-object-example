# This will guess the User class
FactoryBot.define do
  factory :user do
    name { Faker::Superhero.name }

    trait :inactive do
      status { 'inactive' }
    end
  end
end
