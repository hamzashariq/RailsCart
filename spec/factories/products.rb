FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    stock { Faker::Number.between(from: 1, to: 100) }
    price { Faker::Commerce.price(range: 10.0..500.0) }
    association :company

    trait :out_of_stock do
      stock { 0 }
    end

    trait :expensive do
      price { Faker::Commerce.price(range: 500.0..1000.0) }
    end

    trait :cheap do
      price { Faker::Commerce.price(range: 1.0..20.0) }
    end

    factory :expensive_product, traits: [:expensive]
    factory :cheap_product, traits: [:cheap]
    factory :out_of_stock_product, traits: [:out_of_stock]
  end
end
