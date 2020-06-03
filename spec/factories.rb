require 'faker'

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Lorem.characters(number: 6) }

    trait :saved do
      password_confirmation { password }
    end

    trait :favorite_list do
      after :create do |user|
        create_list(:favorite, 5, user_id: user.id)
      end
    end
  end

  factory :home do
    title { Faker::Lorem.paragraph_by_chars(number: 80) }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    country { Faker::Address.country }
    rent { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    room_type { %w[individual shared].sample }
    more_info { Faker::Lorem.paragraph_by_chars(number: 300) }
    user_id { create(:user, :saved).id }
  end

  factory :favorite do
    user_id { create(:user, :saved).id }
    home_id { create(:home).id }
    user_home { "#{user_id}_#{home_id}" }
  end
end
