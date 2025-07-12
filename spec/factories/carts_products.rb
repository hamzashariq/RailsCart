FactoryBot.define do
  factory :carts_product do
    association :cart
    association :product
    quantity { Faker::Number.between(from: 1, to: 5) }

    trait :large_quantity do
      quantity { Faker::Number.between(from: 10, to: 20) }
    end
  end
end
