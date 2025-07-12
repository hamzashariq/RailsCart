FactoryBot.define do
  factory :delivery_information do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    address { Faker::Address.full_address }
    number { Faker::PhoneNumber.phone_number }
    city { Faker::Address.city }
    country { Faker::Address.country }
    association :order
  end
end
