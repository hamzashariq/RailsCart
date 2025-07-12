FactoryBot.define do
  factory :review do
    rating { Faker::Number.between(from: 1, to: 5) }
    description { Faker::Lorem.paragraph }
    association :user
    association :product

    trait :excellent do
      rating { 5 }
      description { "Excellent product! Highly recommended." }
    end

    trait :good do
      rating { 4 }
      description { "Good product, satisfied with the purchase." }
    end

    trait :average do
      rating { 3 }
      description { "Average product, meets expectations." }
    end

    trait :poor do
      rating { 2 }
      description { "Below expectations, could be better." }
    end

    trait :terrible do
      rating { 1 }
      description { "Terrible product, would not recommend." }
    end

    factory :excellent_review, traits: [:excellent]
    factory :good_review, traits: [:good]
    factory :average_review, traits: [:average]
    factory :poor_review, traits: [:poor]
    factory :terrible_review, traits: [:terrible]
  end
end
