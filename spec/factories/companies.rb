FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    subdomain { Faker::Internet.domain_word }
    about_page_content { Faker::Lorem.paragraphs(number: 3).join("\n\n") }
    contact_page_content { Faker::Lorem.paragraphs(number: 2).join("\n\n") }

    trait :with_subdomain do |subdomain_name|
      subdomain { subdomain_name }
    end
  end
end
