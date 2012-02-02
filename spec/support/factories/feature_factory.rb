FactoryGirl.define do
  factory :feature do
    name  { Faker::Lorem.words(1) }
  end
end
