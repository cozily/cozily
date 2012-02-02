FactoryGirl.define do
  factory :neighborhood_profile do
    association :neighborhood
    association :profile
  end
end
