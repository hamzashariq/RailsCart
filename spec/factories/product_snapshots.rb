FactoryBot.define do
  factory :product_snapshot do
    name { Faker::Commerce.product_name }
    price { Faker::Commerce.price(range: 10.0..500.0) }
    quantity { Faker::Number.between(from: 1, to: 5) }
    association :order
  end
end
