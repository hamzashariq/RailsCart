FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    password { "password123" }
    password_confirmation { "password123" }
    user_type { "customer" }
    association :company

    trait :admin do
      user_type { "admin" }
    end

    trait :customer do
      user_type { "customer" }
    end

    factory :admin_user, traits: [:admin]
    factory :customer_user, traits: [:customer]
  end
end
