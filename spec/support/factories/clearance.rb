FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    first_name            { Faker::Name.first_name }
    last_name             { Faker::Name.last_name }
    email                 { Factory.next(:email) }
    password              { "password" }
    password_confirmation { "password" }
    role_ids              { [Role.find_by_name("finder").id] }
  end

  factory :lister, :parent => :user do
    role_ids { [Role.find_by_name("lister").id] }
    phone { "202-270-7370" }
  end
end
