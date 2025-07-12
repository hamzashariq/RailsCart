FactoryBot.define do
  factory :cart do
    association :user
    association :company

    trait :with_products do
      after(:create) do |cart|
        create_list(:carts_product, 3, cart: cart)
      end
    end

    factory :cart_with_products, traits: [:with_products]
  end
end
