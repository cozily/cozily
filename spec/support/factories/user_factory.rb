FactoryGirl.define do
  factory :user do
    first_name            { Faker::Name.first_name }
    last_name             { Faker::Name.last_name }
    email                 { Faker::Internet.email }
    password              { "password" }
    password_confirmation { "password" }
    role_ids              { [Role.find_by_name("finder").id] }
  end

  factory :lister, :parent => :user do
    role_ids { [Role.find_by_name("lister").id] }
    phone { Faker::PhoneNumber.short_phone_number }
  end
end

