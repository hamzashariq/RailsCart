FactoryBot.define do
  factory :order_history do
    note { "Order status updated" }
    status_from { "pending" }
    status_to { "confirmed" }
    association :order

    trait :initial do
      note { "Order placed" }
      status_from { nil }
      status_to { "pending" }
    end

    trait :confirmed do
      note { "Order confirmed" }
      status_from { "pending" }
      status_to { "confirmed" }
    end

    trait :shipped do
      note { "Order shipped" }
      status_from { "confirmed" }
      status_to { "shipped" }
    end

    trait :delivered do
      note { "Order delivered" }
      status_from { "shipped" }
      status_to { "delivered" }
    end

    trait :cancelled do
      note { "Order cancelled" }
      status_to { "cancelled" }
    end
  end
end
