FactoryBot.define do
  factory :order do
    association :user
    association :company
    delivery_status { :pending }

    trait :confirmed do
      delivery_status { :confirmed }
    end

    trait :shipped do
      delivery_status { :shipped }
    end

    trait :delivered do
      delivery_status { :delivered }
    end

    trait :cancelled do
      delivery_status { :cancelled }
    end

    trait :with_delivery_information do
      after(:create) do |order|
        create(:delivery_information, order: order)
      end
    end

    trait :with_product_snapshots do
      after(:create) do |order|
        create_list(:product_snapshot, 3, order: order)
      end
    end

    factory :confirmed_order, traits: [:confirmed]
    factory :shipped_order, traits: [:shipped]
    factory :delivered_order, traits: [:delivered]
    factory :cancelled_order, traits: [:cancelled]
    factory :complete_order, traits: [:with_delivery_information, :with_product_snapshots]
  end
end
